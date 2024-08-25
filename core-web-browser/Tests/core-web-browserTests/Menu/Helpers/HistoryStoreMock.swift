import core_web_browser

class HistoryStoreMock: HistoryAPI {
    enum Message: Equatable {
        case getPages
        case getPagesByTerm(String)
    }
    
    var receivedMessages = [Message]()
    var mockWebPages = [[WebPage]]()

    func save(page: WebPage) {

    }

    func getPages() -> [[WebPage]] {
        receivedMessages.append(.getPages)
        return mockWebPages
    }

    func getPages(by searchTerm: String) -> [[WebPage]] {
        receivedMessages.append(.getPagesByTerm(searchTerm))
        return mockWebPages
    }
}
