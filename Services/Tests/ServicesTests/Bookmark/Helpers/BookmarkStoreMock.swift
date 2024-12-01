import Foundation
import Services

class BookmarkStoreMock: BookmarkStoreAPI {
    enum Message: Equatable {
        case save(String)
        case getPages
        case getPagesByTerm(String)
        case deletePages([UUID])
    }

    var receivedMessages = [Message]()
    var mockBookmarks = [BookmarkModel]()

    func save(_ bookmark: BookmarkModel) {
        receivedMessages.append(.save(bookmark.url.absoluteString))
    }

    func getPages() -> [BookmarkModel] {
        receivedMessages.append(.getPages)
        return mockBookmarks
    }

    func getPages(by searchTerm: String) -> [BookmarkModel] {
        receivedMessages.append(.getPagesByTerm(searchTerm))
        return mockBookmarks
    }

    func deletePages(withIDs ids: [UUID]) {
        receivedMessages.append(.deletePages(ids))
    }
}
