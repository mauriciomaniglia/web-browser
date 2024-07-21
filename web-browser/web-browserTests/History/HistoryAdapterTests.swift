import XCTest
@testable import web_browser

class HistoryAdapterTests: XCTestCase {

    func test_didOpenHistoryView_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenHistoryView])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didSelectPageHistory_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()
        let pageHistory = HistoryViewModel.HistoryPage(title: "some title", url: URL(string: "http://some-url.com")!)

        sut.didSelectPageHistory(pageHistory)

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, presenter, viewModel, webView) = makeSUT()
        let historyPage = HistoryPresentableModel.HistoryPage(title: "title", url: URL(string: "https://some-url.com")!)
        let model = HistoryPresentableModel(historyList: [historyPage])

        sut.updateViewModel(model)

        XCTAssertEqual(viewModel.historyList.first?.title, "title")
        XCTAssertEqual(viewModel.historyList.first?.url.absoluteString, "https://some-url.com")
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
