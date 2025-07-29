import Foundation
import Combine

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
            didSearchTerm?(searchText)
        }
    }

    var didTapAddBookmark: ((String, String) -> Void)?
    var didOpenBookmarkView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPage: ((URL) -> Void)?
    var didTapDeletePages: (([UUID]) -> Void)?

    func setSelectedBookmark(_ bookmark: Bookmark) {
        selectedBookmark = bookmark
    }

    func removeSelectedBookmark() {
        if let selectedBookmark {
            bookmarkList.removeAll(where: { $0.id == selectedBookmark.id})
            didTapDeletePages?([selectedBookmark.id])
        }
    }

    func undoCurrentSelection() {
        selectedBookmark = nil
    }

    func deleteBookmarks(at offsets: IndexSet) {
        let pagesToDelete = offsets.compactMap { index in
            bookmarkList[index]
        }

        didTapDeletePages?(pagesToDelete.map { $0.id })
    }
}
