import XCTest
@testable import web_browser

class MenuAdapterTests: XCTestCase {

    func test_didTapMenu_sendsCorrectMessage() {
        let (sut, presenter, _, _) = makeSUT()

        sut.didTapMenu()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenMenuView])
    }

    func test_didTapHistory_sendsCorrectMessage() {
        let (sut, presenter, _, _) = makeSUT()

        sut.didTapHistory()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenHistoryView])
    }

    func test_didSelectPageHistory_sendsCorrectMessage() {
        let (sut, presenter, _, webView) = makeSUT()
        let pageHistory = MenuViewModel.HistoryPage(title: "some title", url: URL(string: "http://some-url.com")!)

        sut.didSelectPageHistory(pageHistory)

        XCTAssertEqual(presenter.receivedMessages, [.didSelectPageHistory])
        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://some-url.com")!)])
    }

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, _, viewModel, _) = makeSUT()
        let historyPage = MenuModel.HistoryPage(title: "title", url: URL(string: "https://some-url.com")!)
        let model = MenuModel(showMenu: true, historyList: [historyPage])

        sut.updateViewModel(model)

        XCTAssertTrue(viewModel.showMenu)
        XCTAssertTrue(viewModel.showHistory)
        XCTAssertEqual(viewModel.historyList.first?.title, "title")
        XCTAssertEqual(viewModel.historyList.first?.url.absoluteString, "https://some-url.com")
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: MenuAdapter, presenter: MenuPresenterSpy, viewModel: MenuViewModel, webView: WebViewSpy) {
        let viewModel = MenuViewModel()
        let history = HistoryStoreMock()
        let presenter = MenuPresenterSpy(history: history)
        let webView = WebViewSpy()
        let sut = MenuAdapter(viewModel: viewModel, presenter: presenter, webView: webView)

        return (sut, presenter, viewModel, webView)
    }
}
