import core_web_browser

class HistoryStoreMock: HistoryAPI {
    enum Message {
        case getPages
        case getPagesByTerm
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
        receivedMessages.append(.getPagesByTerm)
        return mockWebPages
    }
}
