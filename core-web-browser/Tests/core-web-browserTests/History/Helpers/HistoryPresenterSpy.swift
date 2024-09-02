@testable import core_web_browser

class HistoryPresenterSpy: HistoryPresenter {
    enum Message: Equatable {
        case didOpenHistoryView
        case didSearchTerm(String)
    }

    var receivedMessages = [Message]()

    override func didOpenHistoryView() {
        receivedMessages.append(.didOpenHistoryView)
    }

    override func didSearchTerm(_ term: String) {
        receivedMessages.append(.didSearchTerm(term))
    }
}
