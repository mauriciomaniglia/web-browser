import Foundation

public struct BookmarkModel {
    public let id: UUID
    public let title: String?
    public let url: URL

    public init(id: UUID = UUID(), title: String?, url: URL) {
        self.id = id
        self.title = title
        self.url = url
    }
}
