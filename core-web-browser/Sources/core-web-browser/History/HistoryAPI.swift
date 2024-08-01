public protocol HistoryAPI {
    func save(page: WebPage)
    func getPages() -> [WebPage]
    func getPages(by searchTerm: String) -> [WebPage]
}
