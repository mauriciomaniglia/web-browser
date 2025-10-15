import Foundation

public protocol SearchSuggestionPresenterDelegate: AnyObject {
    func didUpdatePresentableModel(_ model: SearchSuggestionPresenter.Model)
}

public class SearchSuggestionPresenter {

    public struct Model: Equatable {

        public struct Bookmark: Equatable {
            public let title: String
            public let url: URL
        }

        public struct HistoryPage: Equatable {
            public let title: String
            public let url: URL
        }

        public struct SearchSuggestion: Equatable {
            public let title: String
            public let url: URL
        }

        public let bookmarkSuggestions: [Bookmark]
        public let historyPageSuggestions: [HistoryPage]
        public let searchSuggestions: [SearchSuggestion]
    }

    public weak var delegate: SearchSuggestionPresenterDelegate?

    public init() {}

    public func didLoad(
        searchSuggestions: [String],
        historyModels: [HistoryPageModel],
        bookmarkModels: [BookmarkModel])
    {
        let searchSuggestionModels = searchSuggestions.map { suggestion in
            Model.SearchSuggestion(
                title: suggestion,
                url: URLBuilderAPI.makeURL(from: suggestion)
            )
        }
        .prefix(10)
        .map { $0 }

        let historySuggestions = historyModels.compactMap { model in
            model.title.map { Model.HistoryPage(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let bookmarkSuggestions = bookmarkModels.compactMap { model in
            model.title.map { Model.Bookmark(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let model = Model(
            bookmarkSuggestions: bookmarkSuggestions,
            historyPageSuggestions: historySuggestions,
            searchSuggestions: searchSuggestionModels
        )

        delegate?.didUpdatePresentableModel(model)
    }
}
