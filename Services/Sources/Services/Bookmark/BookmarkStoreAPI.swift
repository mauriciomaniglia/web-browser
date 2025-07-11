import Foundation

public protocol BookmarkStoreAPI {
    func save(title: String, url: String)
    func getPages() -> [BookmarkModel]
    func getPages(by searchTerm: String) -> [BookmarkModel]
    func deletePages(withIDs ids: [UUID])
}
