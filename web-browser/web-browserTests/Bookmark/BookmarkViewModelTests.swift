import XCTest
@testable import web_browser

@MainActor
class BookmarkViewModelTests: XCTestCase {

    func test_setSelectedBookmark_shouldSetSelectedBookmark() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewModel.Bookmark(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)

        XCTAssertEqual(sut.selectedBookmark, bookmark)
    }

    func test_undoCurrentSelection_shouldRemoveSelectedBookmark() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewModel.Bookmark(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)
        sut.undoCurrentSelection()

        XCTAssertNil(sut.selectedBookmark)
    }

    func test_removeSelectedBookmark_shouldRemoveSelectedBookmarkFromTheList() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 2", url: url)
        let bookmark3 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 3", url: url)
        sut.bookmarkList = [bookmark1, bookmark2, bookmark3]

        sut.setSelectedBookmark(bookmark1)
        sut.removeSelectedBookmark()

        XCTAssertFalse(sut.bookmarkList.contains(bookmark1))
    }

    func test_removeSelectedBookmark_shouldInformBookmarksToDelete() {
        let (sut, delegate) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 2", url: url)
        sut.bookmarkList = [bookmark1, bookmark2]

        sut.setSelectedBookmark(bookmark1)
        sut.removeSelectedBookmark()

        XCTAssertEqual(delegate.receivedMessages, [.didTapDeletePages([bookmark1.id])])
    }

    func test_deleteBookmarksAt_shouldRemoveBookmarksAtIndexesFromTheList() {
        let (sut, delegate) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 2", url: url)
        let bookmark3 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 3", url: url)
        sut.bookmarkList = [bookmark1, bookmark2, bookmark3]

        sut.deleteBookmarks(at: [0, 1])

        XCTAssertEqual(delegate.receivedMessages, [.didTapDeletePages([bookmark1.id, bookmark2.id])])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkViewModel, delegate: BookmarkViewModelDelegateMock) {
        let sut = BookmarkViewModel()
        let delegate = BookmarkViewModelDelegateMock()
        sut.delegate = delegate

        return (sut, delegate)
    }
}

private class BookmarkViewModelDelegateMock: BookmarkViewModelDelegate {
    enum Message: Equatable {
        case didTapDeletePages(_ pages: [UUID])
    }

    var receivedMessages = [Message]()

    func didTapAddBookmark(name: String, urlString: String) {}

    func didOpenBookmarkView() {}

    func didSearchTerm(_ query: String) {}

    func didSelectPage(_ pageURL: URL) {}

    func didTapDeletePages(_ pagesID: [UUID]) {
        receivedMessages.append(.didTapDeletePages(pagesID))
    }
}
