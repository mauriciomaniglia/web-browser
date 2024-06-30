import XCTest
@testable import web_browser

class MenuAdapterTests: XCTestCase {

    func test_didTapMenu_sendsCorrectMessage() {
        let (sut, presenter) = makeSU()

        sut.didTapMenu()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenMenuView])
    }

    // MARK: - Helpers

    private func makeSU() -> (sut: MenuAdapter, presenter: MenuPresenterSpy) {
        let viewModel = MenuViewModel()
        let history = HistoryStoreMock()
        let presenter = MenuPresenterSpy(history: history)
        let sut = MenuAdapter(viewModel: viewModel, presenter: presenter)

        return (sut, presenter)
    }
}

private class MenuPresenterSpy: MenuPresenter {
    enum Message {
        case didOpenMenuView
    }

    var receivedMessages = [Message]()

    override func didOpenMenuView() {
        receivedMessages.append(.didOpenMenuView)
    }
}
