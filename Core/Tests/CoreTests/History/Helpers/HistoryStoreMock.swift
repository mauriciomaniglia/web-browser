import Foundation
import Core

class HistoryStoreMock: HistoryAPI {
    enum Message: Equatable {
        case getPages
        case getPagesByTerm(String)
        case deletePages([UUID])
        case deleteAllPages
    }
    
    var receivedMessages = [Message]()
    var mockWebPages = [WebPage]()

    func save(page: WebPage) {

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

    func deleteAllPages() {
        receivedMessages.append(.deleteAllPages)
    }
}
