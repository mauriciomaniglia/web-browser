import Foundation

public class SearchSuggestionPresenter {

    public init() {}

    public func didLoad(
        searchSuggestions: [String],
        historyPages: [WebPageModel],
        bookmarkModels: [BookmarkModel]) -> PresentableSearchSuggestion
    {
        let searchSuggestionModels = searchSuggestions.map { suggestion in
            PresentableSearchSuggestion.SearchSuggestion(
                title: suggestion,
                url: URLBuilderAPI.makeURL(from: suggestion)
            )
        }
        .prefix(10)
        .map { $0 }

        let historySuggestions = historyPages.compactMap { model in
            model.title.map { PresentableSearchSuggestion.HistoryPage(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let bookmarkSuggestions = bookmarkModels.compactMap { model in
            model.title.map { PresentableSearchSuggestion.Bookmark(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let model = PresentableSearchSuggestion(
            bookmarkSuggestions: bookmarkSuggestions,
            historyPageSuggestions: historySuggestions,
            searchSuggestions: searchSuggestionModels
        )

        return model
    }
}

public struct PresentableSearchSuggestion: Equatable {

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
