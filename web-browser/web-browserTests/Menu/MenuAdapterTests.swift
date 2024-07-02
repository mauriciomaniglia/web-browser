import XCTest
@testable import web_browser

class MenuAdapterTests: XCTestCase {

    func test_didTapMenu_sendsCorrectMessage() {
        let (sut, presenter, _) = makeSU()

        sut.didTapMenu()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenMenuView])
    }

    func test_didTapHistory_sendsCorrectMessage() {
        let (sut, presenter, _) = makeSU()

        sut.didTapHistory()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenHistoryView])
    }

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, _, viewModel) = makeSU()
        let historyPage = MenuModel.HistoryPage(title: "title", url: URL(string: "https://some-url.com")!)
        let model = MenuModel(showMenu: true, historyList: [historyPage])

        sut.updateViewModel(model)

        XCTAssertTrue(viewModel.showMenu)
        XCTAssertTrue(viewModel.showHistory)
        XCTAssertEqual(viewModel.historyList.first?.title, "title")
        XCTAssertEqual(viewModel.historyList.first?.url.absoluteString, "https://some-url.com")
    }

    // MARK: - Helpers

    private func makeSU() -> (sut: MenuAdapter, presenter: MenuPresenterSpy, viewModel: MenuViewModel) {
        let viewModel = MenuViewModel()
        let history = HistoryStoreMock()
        let presenter = MenuPresenterSpy(history: history)
        let sut = MenuAdapter(viewModel: viewModel, presenter: presenter)

        return (sut, presenter, viewModel)
    }
}
