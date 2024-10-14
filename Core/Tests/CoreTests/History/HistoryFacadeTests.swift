import XCTest
import Core

class HistoryFacadeTests: XCTestCase {

    func test_didLoadPages_sendsCorrectMessage() {
        let (sut, presenter,webView, history) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPages])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter,webView, history) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPagesByTerm("test")])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, presenter, webView, history) = makeSUT()

        sut.didSearchTerm("")

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPages])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSelectPageHistory_sendsCorrectMessage() {
        let (sut, presenter,webView, history) = makeSUT()

        sut.didSelectPage("http://some-url.com")

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    func test_didTapDeletePages_sendsCorrectMessage() {
        let (sut, presenter,webView, history) = makeSUT()
        let page1ID = UUID()
        let page2ID = UUID()

        sut.didTapDeletePages([page1ID, page2ID])
        
        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [.deletePages([page1ID, page2ID])])
    }

    func test_didTapDeleteAllPages_sendsCorrectMessage() {
        let (sut, presenter,webView, history) = makeSUT()

        sut.didTapDeleteAllPages()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [.deleteAllPages])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryFacade, presenter: HistoryPresenterSpy, webView: WebViewSpy, history: HistoryStoreMock) {
        let history = HistoryStoreMock()
        let presenter = HistoryPresenterSpy()
        let webView = WebViewSpy()
        let sut = HistoryFacade(presenter: presenter, webView: webView, history: history)

        return (sut, presenter, webView, history)
    }
}
