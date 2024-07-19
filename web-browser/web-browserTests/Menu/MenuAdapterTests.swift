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

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, _, viewModel, _) = makeSUT()
        let model = MenuModel(showMenu: true, showHistory: true)

        sut.updateViewModel(model)

        XCTAssertTrue(viewModel.showMenu)
        XCTAssertTrue(viewModel.showHistory)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: MenuAdapter, presenter: MenuPresenterSpy, viewModel: MenuViewModel, webView: WebViewSpy) {
        let webView = WebViewSpy()
        let viewModel = MenuViewModel(webView: webView)
        let presenter = MenuPresenterSpy()
        let sut = MenuAdapter(viewModel: viewModel, presenter: presenter, webView: webView)

        return (sut, presenter, viewModel, webView)
    }
}
