@testable import Services

class HistoryPresenterSpy: HistoryPresenter {
    enum Message: Equatable {
        case didLoadPages        
    }

    var receivedMessages = [Message]()

    override func didLoadPages(_ pages: [HistoryPageModel]) {
        receivedMessages.append(.didLoadPages)
    }
}
