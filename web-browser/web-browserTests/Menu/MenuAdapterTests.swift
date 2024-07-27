import XCTest
@testable import core_web_browser
@testable import web_browser

class MenuAdapterTests: XCTestCase {

    func test_updateViewModel_deliversCorrectState() {
        let (sut, viewModel) = makeSUT()
        let model = MenuPresentableModel(showMenu: true, showHistory: true)

        sut.updateViewModel(model)

        XCTAssertTrue(viewModel.showMenu)
        XCTAssertTrue(viewModel.showHistory)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: MenuAdapter, viewModel: MenuViewModel) {
        let webView = WebViewSpy()
        let viewModel = MenuViewModel(webView: webView)
        let sut = MenuAdapter(viewModel: viewModel)

        return (sut, viewModel)
    }
}
