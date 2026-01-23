import Foundation

public class BookmarkManager {
    private let bookmarkStore: BookmarkStoreAPI

    public init(bookmarkStore: BookmarkStoreAPI)
    {
        self.bookmarkStore = bookmarkStore
    }

    public func didOpenBookmarkView() -> [PresentableBookmark] {
        let webPages = bookmarkStore.getPages()
        return mapBookmarks(from: webPages)
    }

    public func didSearchTerm(_ term: String) -> [PresentableBookmark] {
        let webPages = term.isEmpty ? bookmarkStore.getPages() : bookmarkStore.getPages(by: term)
        return mapBookmarks(from: webPages)
    }

    private func mapBookmarks(from models: [BookmarkModel]) -> [PresentableBookmark] {
        let presentableModels = models.map {
            let title = $0.title ?? $0.url.absoluteString
            return PresentableBookmark(id: $0.id, title: title, url: $0.url)
        }

        return presentableModels
    }
}

public struct PresentableBookmark: Equatable {
    public let id: UUID
    public let title: String
    public let url: URL
}
