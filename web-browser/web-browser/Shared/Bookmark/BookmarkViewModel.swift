import Foundation
import Combine

protocol BookmarkViewModelDelegate: AnyObject {
    func didTapAddBookmark(name: String, urlString: String)
    func didOpenBookmarkView()
    func didSearchTerm(_ query: String)
    func didSelectPage(_ pageURL: URL)
    func didTapDeletePages(_ pagesID: [UUID])
}

class BookmarkViewModel: ObservableObject {

    struct Bookmark: Identifiable, Equatable {
        let id: UUID
        let title: String
        let url: URL
    }

    @Published var bookmarkList: [Bookmark] = []
    var selectedBookmark: Bookmark?

    @Published var searchText: String = "" {
        didSet {
            delegate?.didSearchTerm(searchText)
        }
    }

    weak var delegate: BookmarkViewModelDelegate?

    func setSelectedBookmark(_ bookmark: Bookmark) {
        selectedBookmark = bookmark
    }

    func removeSelectedBookmark() {
        if let selectedBookmark {
            bookmarkList.removeAll(where: { $0.id == selectedBookmark.id})
            delegate?.didTapDeletePages([selectedBookmark.id])
        }
    }

    func undoCurrentSelection() {
        selectedBookmark = nil
    }

    func deleteBookmarks(at offsets: IndexSet) {
        let pagesToDelete = offsets.compactMap { index in
            bookmarkList[index]
        }

        delegate?.didTapDeletePages(pagesToDelete.map { $0.id })
    }
}
