public class BookmarkPresenter {
    public var didUpdatePresentableModels: (([BookmarkPresentableModel]) -> Void)?

    public init() {}

    public func mapBookmarks(from pages: [WebPage]) {
        let presentableModels = pages.map {
            let title = $0.title ?? $0.url.absoluteString
            return BookmarkPresentableModel(id: $0.id, title: title, url: $0.url)
        }

        didUpdatePresentableModels?(presentableModels)
    }
}

