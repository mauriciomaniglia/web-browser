@testable import Services

class BookmarkPresenterSpy: BookmarkPresenter {
    enum Message: Equatable {
        case mapBookmarks
    }

    var receivedMessages = [Message]()

    override func mapBookmarks(from pages: [BookmarkModel]) {
        receivedMessages.append(.mapBookmarks)
    }
}
