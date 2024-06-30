import XCTest
import core_web_browser
@testable import web_browser

class MenuAdapterTests: XCTestCase {

    func test_didTapMenu_sendsCorrectMessage() {
        let viewModel = MenuViewModel()
        let history = HistoryStoreMock()
        let presenter = MenuPresenterSpy(history: history)
        let sut = MenuAdapter(viewModel: viewModel, presenter: presenter)

        sut.didTapMenu()

        XCTAssertEqual(presenter.receivedMessages, [.didOpenMenuView])
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

private class HistoryStoreMock: HistoryAPI {
    var mockWebPages = [WebPage]()

    func save(page: WebPage) {

    }

    func getPages() -> [WebPage] {
        return mockWebPages
    }
}
