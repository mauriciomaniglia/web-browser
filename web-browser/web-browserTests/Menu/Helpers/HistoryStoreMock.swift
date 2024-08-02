import core_web_browser

class HistoryStoreMock: HistoryAPI {
    var mockWebPages = [WebPage]()

    func save(page: WebPage) {

    }

    func getPages() -> [WebPage] {
        return mockWebPages
    }

    func getPages(by searchTerm: String) -> [core_web_browser.WebPage] {
        return []
    }
}
