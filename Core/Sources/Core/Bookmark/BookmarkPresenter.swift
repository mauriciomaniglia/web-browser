public class BookmarkPresenter {
    public init() {}

    public func mapBookmarks(from pages: [WebPage]) -> [BookmarkPresentableModel] {
        pages.map {
            let title = $0.title ?? $0.url.absoluteString
            return BookmarkPresentableModel(id: $0.id, title: title, url: $0.url)
        }
    }
}

