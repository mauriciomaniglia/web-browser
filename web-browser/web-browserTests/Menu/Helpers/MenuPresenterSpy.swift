@testable import web_browser

class MenuPresenterSpy: MenuPresenter {
    enum Message {
        case didOpenMenuView
        case didOpenHistoryView
        case didSelectPageHistory
    }

    var receivedMessages = [Message]()

    override func didOpenMenuView() {
        receivedMessages.append(.didOpenMenuView)
    }

    override func didOpenHistoryView() {
        receivedMessages.append(.didOpenHistoryView)
    }

    override func didSelectPageHistory() {
        receivedMessages.append(.didSelectPageHistory)
    }
}
