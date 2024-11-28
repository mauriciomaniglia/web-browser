import Foundation
import Services

class HistoryStoreMock: HistoryAPI {
    enum Message: Equatable {
        case getPages
        case getPagesByTerm(String)
        case deletePages([UUID])
        case deleteAllPages
    }
    
    var receivedMessages = [Message]()
    var mockWebPages = [HistoryPageModel]()

    func save(_ page: HistoryPageModel) {

    }

    func getPages() -> [HistoryPageModel] {
        receivedMessages.append(.getPages)
        return mockWebPages
    }

    func getPages(by searchTerm: String) -> [HistoryPageModel] {
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
