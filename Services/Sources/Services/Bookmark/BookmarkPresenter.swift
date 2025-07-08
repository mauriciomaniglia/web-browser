import Foundation

public class BookmarkPresenter {
    public struct Model {
        public let id: UUID
        public let title: String
        public let url: URL
    }

    public var didUpdatePresentableModels: (([Model]) -> Void)?

    public init() {}

    public func mapBookmarks(from models: [BookmarkModel]) {
        let presentableModels = models.map {
            let title = $0.title ?? $0.url.absoluteString
            return Model(id: $0.id, title: title, url: $0.url)
        }

        didUpdatePresentableModels?(presentableModels)
    }
}

