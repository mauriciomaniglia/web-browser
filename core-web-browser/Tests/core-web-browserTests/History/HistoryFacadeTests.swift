import XCTest
import core_web_browser

class HistoryFacadeTests: XCTestCase {

    func test_didLoadPages_sendsCorrectMessage() {
        let (sut, presenter,webView, _) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
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
        let (sut, presenter,webView, _) = makeSUT()

        sut.didSelectPage("http://some-url.com")

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
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
