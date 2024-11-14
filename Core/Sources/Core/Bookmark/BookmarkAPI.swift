import Foundation

public protocol BookmarkAPI {
    func save(_ page: WebPage)
    func getPages() -> [WebPage]
    func getPages(by searchTerm: String) -> [WebPage]
    func deletePages(withIDs ids: [UUID])
}
