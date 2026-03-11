import Foundation

public protocol BookmarkManagerAPI {
    func didOpenBookmarkView() -> [BookmarkViewData]
    func didSearchTerm(_ term: String) -> [BookmarkViewData]
}

public class BookmarkManager<T: BookmarkStoreAPI>: BookmarkManagerAPI {
    private let bookmarkStore: T

    public init(bookmarkStore: T) {
        self.bookmarkStore = bookmarkStore
    }

    public func didOpenBookmarkView() -> [BookmarkViewData] {
        let webPages = bookmarkStore.getPages()
        return mapBookmarks(from: webPages)
    }

    public func didSearchTerm(_ term: String) -> [BookmarkViewData] {
        let webPages = term.isEmpty ? bookmarkStore.getPages() : bookmarkStore.getPages(by: term)
        return mapBookmarks(from: webPages)
    }

    private func mapBookmarks(from models: [BookmarkModel]) -> [BookmarkViewData] {
        let viewDatas = models.map {
            let title = $0.title ?? $0.url.absoluteString
            return BookmarkViewData(id: $0.id, title: title, url: $0.url)
        }

        return viewDatas
    }
}

public struct BookmarkViewData: Equatable, Identifiable {
    public let id: UUID
    public let title: String
    public let url: URL

    public init(id: UUID, title: String, url: URL) {
        self.id = id
        self.title = title
        self.url = url
    }
}
