import Foundation

class BookmarkViewModel: ObservableObject {

    struct Bookmark: Identifiable {
        let id: UUID
        let title: String
        let url: URL
    }

    @Published var bookmarkList: [Bookmark] = []
    var selectedBookmark: Bookmark?

    var didOpenBookmarkView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPage: ((String) -> Void)?
    var didTapSavePage: ((String, URL) -> Void)?
    var didTapDeletePages: (([UUID]) -> Void)?

    func setSelectedBookmark(_ bookmark: Bookmark) {
        selectedBookmark = bookmark
    }

    func removeSelectedBookmark() {
        bookmarkList.removeAll(where: { $0.id == selectedBookmark?.id})
    }

    func undoCurrentSelection() {
        selectedBookmark = nil
    }
}
