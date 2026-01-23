import XCTest
@testable import Services

class BookmarkManagerTests: XCTestCase {

    func test_didOpenBookmarkView_sendsCorrectMessage() {
        let (sut, bookmarkStore) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        bookmarkStore.mockBookmarks = [bookmark]

        let presentableModels = sut.didOpenBookmarkView()

        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
        XCTAssertEqual(presentableModels.count, 1)
        XCTAssertEqual(presentableModels.first?.title, "Apple Store")
        XCTAssertEqual(presentableModels.first?.url, URL(string: "https://www.apple.com"))
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, bookmarkStore) = makeSUT()
        let bookmark1 = BookmarkModel(title: "Apple Watch", url: URL(string: "https://www.apple.com/watch")!)
        let bookmark2 = BookmarkModel(title: "Apple Music", url: URL(string: "https://www.apple.com/music")!)
        bookmarkStore.mockBookmarks = [bookmark1, bookmark2]

        let presentableModels = sut.didSearchTerm("apple")

        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPagesByTerm("apple")])
        XCTAssertEqual(presentableModels.count, 2)
        XCTAssertEqual(presentableModels.first?.title, "Apple Watch")
        XCTAssertEqual(presentableModels.first?.url, URL(string: "https://www.apple.com/watch"))
        XCTAssertEqual(presentableModels.last?.title, "Apple Music")
        XCTAssertEqual(presentableModels.last?.url, URL(string: "https://www.apple.com/music"))
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, bookmarkStore) = makeSUT()

        _ = sut.didSearchTerm("")

        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkManager, bookmarkStore: BookmarkStoreMock) {
        let bookmarkStore = BookmarkStoreMock()
        let sut = BookmarkManager(bookmarkStore: bookmarkStore)

        return (sut, bookmarkStore)
    }
}
