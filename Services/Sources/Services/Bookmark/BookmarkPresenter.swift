public class BookmarkPresenter {
    public var didUpdatePresentableModels: (([BookmarkPresentableModel]) -> Void)?

    public init() {}

    public func mapBookmarks(from models: [BookmarkModel]) {
        let presentableModels = models.map {
            let title = $0.title ?? $0.url.absoluteString
            return BookmarkPresentableModel(id: $0.id, title: title, url: $0.url)
        }

        didUpdatePresentableModels?(presentableModels)
    }
}

