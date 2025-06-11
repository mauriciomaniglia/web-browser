import XCTest
import Services

class HistoryMediatorTests: XCTestCase {

    func test_didOpenHistoryView_sendsCorrectMessage() {
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

    func test_didSelectPage_sendsCorrectMessage() {
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

    private func makeSUT() -> (sut: HistoryMediator, presenter: HistoryPresenterSpy, webView: WebViewSpy, historyStore: HistoryStoreMock) {
        let historyStore = HistoryStoreMock()
        let presenter = HistoryPresenterSpy()
        let webView = WebViewSpy()
        let sut = HistoryMediator(
            presenter: presenter,
            webView: webView,
            historyStore: historyStore)

        return (sut, presenter, webView, historyStore)
    }
}
