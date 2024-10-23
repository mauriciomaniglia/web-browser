import XCTest
@testable import Core

class BookmarkFacadeTests: XCTestCase {

    func test_didOpenBookmarkView_sendsCorrectMessage() {
        let (sut, presenter,webView, bookmarkStore) = makeSUT()

        sut.didOpenBookmarkView()

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter,webView, bookmarkStore) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPagesByTerm("test")])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, presenter, webView, bookmarkStore) = makeSUT()

        sut.didSearchTerm("")

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSelectPage_sendsCorrectMessage() {
        let (sut, presenter,webView, bookmarkStore) = makeSUT()

        sut.didSelectPage("http://some-url.com")

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(bookmarkStore.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    func test_didTapSavePage_sendsCorrectMessage() {
        let (sut, presenter,webView, bookmarkStore) = makeSUT()

        sut.didTapSavePage(title: "Some title", url: URL(string: "http://some-url.com")!)

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.save("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didTapDeletePages_sendsCorrectMessage() {
        let (sut, presenter,webView, bookmarkStore) = makeSUT()
        let page1ID = UUID()
        let page2ID = UUID()

        sut.didTapDeletePages([page1ID, page2ID])

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.deletePages([page1ID, page2ID])])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkFacade, presenter: BookmarkPresenterSpy, webView: WebViewSpy, bookmarkStore: BookmarkStoreMock) {
        let bookmarkStore = BookmarkStoreMock()
        let presenter = BookmarkPresenterSpy()
        let webView = WebViewSpy()
        let sut = BookmarkFacade(presenter: presenter, webView: webView, bookmark: bookmarkStore)

        return (sut, presenter, webView, bookmarkStore)
    }
}
