import XCTest
@testable import core_web_browser
@testable import web_browser

class HistoryAdapterTests: XCTestCase {

    func test_didOpenHistoryView_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenHistoryView])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.didSearchTerm("test")])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSelectPageHistory_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()
        let pageHistory = HistoryViewModel.Page(title: "some title", url: "http://some-url.com")

        sut.didSelectPage(pageHistory.url)

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    func test_updateViewModel_deliversCorrectState() {
        let (sut, presenter, viewModel, webView) = makeSUT()
        let page = HistoryPresentableModel.Page(title: "title", url: URL(string: "https://some-url.com")!)
        let section = HistoryPresentableModel.Section(title: "title", pages: [page])
        let model = HistoryPresentableModel(list: [section])

        sut.updateViewModel(model)

        XCTAssertEqual(viewModel.historyList.first?.pages.first?.title, "title")
        XCTAssertEqual(viewModel.historyList.first?.pages.first?.url, "https://some-url.com")
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryAdapter, presenter: HistoryPresenterSpy, viewModel: HistoryViewModel, webView: WebViewSpy) {
        let viewModel = HistoryViewModel()
        let history = HistoryStoreMock()
        let presenter = HistoryPresenterSpy(history: history)
        let webView = WebViewSpy()
        let sut = HistoryAdapter(viewModel: viewModel, presenter: presenter, webView: webView)

        return (sut, presenter, viewModel, webView)
    }
}
