import Foundation

public protocol BookmarkStoreAPI {
    func save(_ bookmark: BookmarkModel)
    func getPages() -> [BookmarkModel]
    func getPages(by searchTerm: String) -> [BookmarkModel]
    func deletePages(withIDs ids: [UUID])
}
