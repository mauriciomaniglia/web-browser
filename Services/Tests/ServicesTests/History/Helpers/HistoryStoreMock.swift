import Foundation
import Services

class HistoryStoreMock: HistoryStoreAPI {
    enum Message: Equatable {
        case getPages
        case getPagesByTerm(String)
        case deletePages([UUID])
        case deleteAllPages
    }
    
    var receivedMessages = [Message]()
    var mockWebPages = [WebPageModel]()

    func save(_ page: WebPageModel) {

    }

    func getPages() -> [WebPageModel] {
        receivedMessages.append(.getPages)
        return mockWebPages
    }

    func getPages(by searchTerm: String) -> [WebPageModel] {
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
