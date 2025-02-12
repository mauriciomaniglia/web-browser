import XCTest
@testable import web_browser

class BookmarkViewModelTests: XCTestCase {

    func test_setSelectedBookmark_shouldSetSelectedBookmark() {
        let sut = BookmarkViewModel()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewModel.Bookmark(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)

        XCTAssertEqual(sut.selectedBookmark, bookmark)
    }

    func test_undoCurrentSelection_shouldRemoveSelectedBookmark() {
        let sut = BookmarkViewModel()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewModel.Bookmark(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)
        sut.undoCurrentSelection()

        XCTAssertNil(sut.selectedBookmark)
    }

    func test_removeSelectedBookmark_shouldRemoveSelectedBookmarkFromTheList() {
        let sut = BookmarkViewModel()
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
        let sut = BookmarkViewModel()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 2", url: url)
        var bookmarksToDelete: [UUID] = []
        sut.bookmarkList = [bookmark1, bookmark2]
        sut.didTapDeletePages = { bookmarksToDelete = $0 }

        sut.setSelectedBookmark(bookmark1)
        sut.removeSelectedBookmark()

        XCTAssertEqual(bookmarksToDelete, [bookmark1.id])
    }

    func test_deleteBookmarksAt_shouldRemoveBookmarksAtIndexesFromTheList() {
        let sut = BookmarkViewModel()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 2", url: url)
        let bookmark3 = BookmarkViewModel.Bookmark(id: UUID(), title: "Title 3", url: url)
        var pagesToDelete: [UUID] = []
        sut.bookmarkList = [bookmark1, bookmark2, bookmark3]
        sut.didTapDeletePages = { pagesToDelete = $0 }

        sut.deleteBookmarks(at: [0, 1])

        XCTAssertEqual(pagesToDelete, [bookmark1.id, bookmark2.id])
    }

}
