import Foundation

public protocol BookmarkStoreAPI {
    func save(title: String, url: String)
    func getPages() -> [BookmarkModel]
    func getPages(by searchTerm: String) -> [BookmarkModel]
    func deletePages(withIDs ids: [UUID])
}

public struct BookmarkModel: Equatable {
    public let id: UUID
    public let title: String?
    public let url: URL

    public init(id: UUID = UUID(), title: String?, url: URL) {
        self.id = id
        self.title = title
        self.url = url
    }
}
