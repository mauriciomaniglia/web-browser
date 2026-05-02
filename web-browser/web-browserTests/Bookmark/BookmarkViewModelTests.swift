import Foundation
import Testing
import Services
@testable import web_browser

@MainActor
@Suite
struct BookmarkViewModelTests {

    @Test("Sets selected bookmark")
    func setSelectedBookmark() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewData(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)

        #expect(sut.selectedBookmark == bookmark)
    }

    @Test("Clears the current selection")
    func undoCurrentSelection() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark = BookmarkViewData(id: UUID(), title: "Some Title", url: url)

        sut.setSelectedBookmark(bookmark)
        sut.undoCurrentSelection()

        #expect(sut.selectedBookmark == nil)
    }

    @Test("Removes the selected bookmark from the list")
    func removeSelectedBookmark() {
        let (sut, _) = makeSUT()
        let url = URL(string: "http://some.url.com")!
        let bookmark1 = BookmarkViewData(id: UUID(), title: "Title 1", url: url)
        let bookmark2 = BookmarkViewData(id: UUID(), title: "Title 2", url: url)
        let bookmark3 = BookmarkViewData(id: UUID(), title: "Title 3", url: url)
        sut.bookmarkList = [bookmark1, bookmark2, bookmark3]

        sut.setSelectedBookmark(bookmark1)
        sut.removeSelectedBookmark()

        #expect(!sut.bookmarkList.contains(bookmark1))
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkViewModel, store: BookmarkStoreMock) {
        let store = BookmarkStoreMock()
        let manager = BookmarkManager(bookmarkStore: store)
        let sut = BookmarkViewModel(store: store, manager: manager)

        return (sut, store)
    }
}
