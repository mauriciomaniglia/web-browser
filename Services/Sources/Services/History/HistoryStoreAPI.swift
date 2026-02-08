import Foundation

public protocol HistoryStoreAPI {
    func save(_ page: WebPageModel)
    func getPages() -> [WebPageModel]
    func getPages(by searchTerm: String) -> [WebPageModel]
    func deletePages(withIDs ids: [UUID])
    func deleteAllPages()
}
