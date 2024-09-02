import XCTest
import core_web_browser

class HistoryFacadeTests: XCTestCase {

    func test_didOpenHistoryView_sendsCorrectMessage() {
        let (sut, presenter,webView) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenHistoryView])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter,webView) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.didSearchTerm("test")])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSelectPageHistory_sendsCorrectMessage() {
        let (sut, presenter,webView) = makeSUT()        

        sut.didSelectPage("http://some-url.com")

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryFacade, presenter: HistoryPresenterSpy, webView: WebViewSpy) {
        let history = HistoryStoreMock()
        let presenter = HistoryPresenterSpy(history: history)
        let webView = WebViewSpy()
        let sut = HistoryFacade(presenter: presenter, webView: webView)

        return (sut, presenter, webView)
    }
}
