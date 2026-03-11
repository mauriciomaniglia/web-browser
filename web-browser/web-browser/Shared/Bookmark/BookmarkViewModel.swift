import Foundation
import Combine
import Services

@MainActor
class BookmarkViewModel: ObservableObject {

    struct Bookmark: Identifiable, Equatable {
        let id: UUID
        let title: String
        let url: URL
    }

    @Published var bookmarkList: [Bookmark] = []

    @Published var searchText: String = "" {
        didSet {
            searchTerm(searchText)
        }
    }

    var selectedBookmark: Bookmark?
    var userActionDelegate: BookmarkUserActionDelegate?

    let store: BookmarkStoreAPI
    let manager: BookmarkManagerAPI

    init(store: BookmarkStoreAPI, manager: BookmarkManagerAPI) {
        self.store = store
        self.manager = manager
    }

    func setSelectedBookmark(_ bookmark: Bookmark) {
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
        let presentableModels = manager.didOpenBookmarkView()
        bookmarkList = presentableModels.map { Bookmark(id: $0.id, title: $0.title, url: $0.url) }
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
        let presentableModels = manager.didSearchTerm(query)
        bookmarkList = presentableModels.map { Bookmark(id: $0.id, title: $0.title, url: $0.url) }
    }
}
