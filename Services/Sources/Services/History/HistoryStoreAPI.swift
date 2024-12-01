import Foundation

public protocol HistoryStoreAPI {
    func save(_ page: HistoryPageModel)
    func getPages() -> [HistoryPageModel]
    func getPages(by searchTerm: String) -> [HistoryPageModel]
    func deletePages(withIDs ids: [UUID])
    func deleteAllPages()
}
