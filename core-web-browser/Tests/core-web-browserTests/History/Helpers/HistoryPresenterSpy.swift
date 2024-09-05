@testable import core_web_browser

class HistoryPresenterSpy: HistoryPresenter {
    enum Message: Equatable {
        case didLoadPages
        case didSearchTerm(String)
    }

    var receivedMessages = [Message]()

    override func didLoadPages(_ pages: [[WebPage]]) {
        receivedMessages.append(.didLoadPages)
    }

    override func didSearchTerm(_ term: String) {
        receivedMessages.append(.didSearchTerm(term))
    }
}
