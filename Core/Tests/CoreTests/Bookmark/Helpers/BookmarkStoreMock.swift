import Foundation
import Core

class BookmarkStoreMock: BookmarkAPI {
    enum Message: Equatable {
        case save(String)
        case getPages
        case getPagesByTerm(String)
        case deletePages([UUID])
    }

    var receivedMessages = [Message]()
    var mockWebPages = [WebPage]()

    func save(page: WebPage) {
        receivedMessages.append(.save(page.url.absoluteString))
    }

    func getPages() -> [WebPage] {
        receivedMessages.append(.getPages)
        return mockWebPages
    }

    func getPages(by searchTerm: String) -> [WebPage] {
        receivedMessages.append(.getPagesByTerm(searchTerm))
        return mockWebPages
    }

    func deletePages(withIDs ids: [UUID]) {
        receivedMessages.append(.deletePages(ids))
    }
}
