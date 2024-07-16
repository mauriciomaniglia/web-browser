@testable import web_browser

class HistoryPresenterSpy: HistoryPresenter {
    enum Message {
        case didOpenHistoryView
    }

    var receivedMessages = [Message]()

    override func didOpenHistoryView() {
        receivedMessages.append(.didOpenHistoryView)
    }
}
