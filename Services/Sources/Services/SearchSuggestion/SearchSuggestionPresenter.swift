import Foundation

public class SearchSuggestionPresenter {

    public struct Model {

        public struct Bookmark {
            public let title: String
            public let url: URL
        }

        public struct HistoryPage {
            public let title: String
            public let url: URL
        }

        public struct SearchSuggestion {
            public let title: String
            public let url: URL
        }

        public let bookmarkSuggestions: [Bookmark]
        public let historyPageSuggestions: [HistoryPage]
        public let searchSuggestions: [SearchSuggestion]
    }

    public var didUpdatePresentableModel: ((Model) -> Void)?

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

        didUpdatePresentableModel?(model)
    }
}
