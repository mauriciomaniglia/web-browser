import Foundation

public protocol BookmarkPresenterDelegate: AnyObject {
    func didUpdatePresentableModels(_ models: [BookmarkPresenter.Model])
}

public class BookmarkPresenter {
    public struct Model: Equatable {
        public let id: UUID
        public let title: String
        public let url: URL
    }

    public weak var delegate: BookmarkPresenterDelegate?

    public init() {}

    public func mapBookmarks(from models: [BookmarkModel]) {
        let presentableModels = models.map {
            let title = $0.title ?? $0.url.absoluteString
            return Model(id: $0.id, title: title, url: $0.url)
        }

        delegate?.didUpdatePresentableModels(presentableModels)
    }
}

