public protocol HistoryAPI {
    func save(page: WebPage)
    func getPages() -> [WebPage]
}
