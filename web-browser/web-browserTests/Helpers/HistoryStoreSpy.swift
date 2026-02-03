import Foundation
@testable import web_browser
@testable import Services

class HistoryStoreSpy: HistoryStoreAPI {
    enum Message: Equatable {
        case save(_ url: URL)
        case getPages
        case deletePages
        case deleteAllPages
    }

    var receivedMessages = [Message]()

    func save(_ page: WebPage) {
        receivedMessages.append(.save(page.url))
    }

    func getPages() -> [WebPage] {
        receivedMessages.append(.getPages)
        return []
    }

    func getPages(by searchTerm: String) -> [WebPage] {
        return []
    }

    func deletePages(withIDs ids: [UUID]) {
        receivedMessages.append(.deletePages)
    }

    func deleteAllPages() {
        receivedMessages.append(.deleteAllPages)
    }
}
