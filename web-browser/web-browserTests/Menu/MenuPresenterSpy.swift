@testable import web_browser

class MenuPresenterSpy: MenuPresenter {
    enum Message {
        case didOpenMenuView
    }

    var receivedMessages = [Message]()

    override func didOpenMenuView() {
        receivedMessages.append(.didOpenMenuView)
    }
}
