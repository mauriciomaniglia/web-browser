@testable import Core

class HistoryPresenterSpy: HistoryPresenter {
    enum Message: Equatable {
        case didLoadPages        
    }

    var receivedMessages = [Message]()

    override func didLoadPages(_ pages: [WebPage]) {
        receivedMessages.append(.didLoadPages)
    }
}
