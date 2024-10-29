import Foundation

class BookmarkViewModel: ObservableObject {

    struct Bookmark: Identifiable, Equatable {
        let id: UUID
        let title: String
        let url: URL
    }

    @Published var bookmarkList: [Bookmark] = []
    var selectedBookmark: Bookmark?

    var didTapAddBookmark: (() -> Void)?
    var didOpenBookmarkView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPage: ((String) -> Void)?
    var didTapSavePage: ((String, URL) -> Void)?
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
}
