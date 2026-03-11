import Foundation
import Combine
import Services

@MainActor
class BookmarkViewModel: ObservableObject {    
    @Published var bookmarkList: [PresentableBookmark] = []

    @Published var searchText: String = "" {
        didSet {
            searchTerm(searchText)
        }
    }

    var selectedBookmark: PresentableBookmark?
    var userActionDelegate: BookmarkUserActionDelegate?

    let store: BookmarkStoreAPI
    let manager: BookmarkManagerAPI

    init(store: BookmarkStoreAPI, manager: BookmarkManagerAPI) {
        self.store = store
        self.manager = manager
    }

    func setSelectedBookmark(_ bookmark: PresentableBookmark) {
        selectedBookmark = bookmark
    }

    func removeSelectedBookmark() {
        if let selectedBookmark {
            bookmarkList.removeAll(where: { $0.id == selectedBookmark.id})
            store.deletePages(withIDs: [selectedBookmark.id])
        }
    }

    func undoCurrentSelection() {
        selectedBookmark = nil
    }

    func didTapAddBookmark(name: String, urlString: String) {
        store.save(title: name, url: urlString)
    }

    func didOpenBookmarkView() {
        bookmarkList = manager.didOpenBookmarkView()
    }

    func didSelectPage(_ pageURL: URL) {
        userActionDelegate?.didSelectPageFromBookmark(pageURL)
    }

    func deleteBookmarks(at offsets: IndexSet) {
        let pagesToDelete = offsets.compactMap { index in
            bookmarkList[index]
        }
        let pagesToDeleteIDs = pagesToDelete.map { $0.id }

        store.deletePages(withIDs: pagesToDeleteIDs)
    }

    private func searchTerm(_ query: String) {
        bookmarkList = manager.didSearchTerm(query)        
    }
}
