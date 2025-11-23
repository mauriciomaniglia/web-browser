import Foundation

public struct PageModel {
    public let id: UUID
    public let title: String?
    public let url: URL
    public let date: Date

    public init(id: UUID = UUID(), title: String?, url: URL, date: Date) {
        self.id = id
        self.title = title
        self.url = url
        self.date = date
    }
}
