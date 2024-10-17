@testable import Core

class BookmarkPresenterSpy: BookmarkPresenter {
    enum Message: Equatable {
        case mapBookmarks
    }

    var receivedMessages = [Message]()

    override func mapBookmarks(from pages: [WebPage]) {
        receivedMessages.append(.mapBookmarks)
    }
}
