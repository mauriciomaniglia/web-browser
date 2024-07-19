@testable import web_browser

class MenuPresenterSpy: MenuPresenter {
    enum Message {
        case didOpenMenuView
        case didOpenHistoryView        
    }

    var receivedMessages = [Message]()

    override func didOpenMenuView() {
        receivedMessages.append(.didOpenMenuView)
    }

    override func didOpenHistoryView() {
        receivedMessages.append(.didOpenHistoryView)
    }
}
