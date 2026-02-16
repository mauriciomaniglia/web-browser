import Foundation

public final class SearchSuggestionManager<S: SearchSuggestionServiceContract, B: BookmarkStoreAPI, H: HistoryStoreAPI> {
    let searchSuggestionService: S
    let bookmarkStore: B
    let historyStore: H

    public init(
        searchSuggestionService: S,
        bookmarkStore: B,
        historyStore: H,
    ) {
        self.searchSuggestionService = searchSuggestionService
        self.bookmarkStore = bookmarkStore
        self.historyStore = historyStore
    }

    public func didStartTyping(query: String) async -> PresentableSearchSuggestion {
        let queryURL = SearchEngineURLBuilder.buildAutocompleteURL(query: query)
        let bookmarkModels = bookmarkStore.getPages(by: query)
        let historyPages = historyStore.getPages(by: query)

        if var suggestions = try? await searchSuggestionService.query(queryURL) {
            suggestions.insert(query, at: 0)
            return mapToPresentableModel(
                searchSuggestions: suggestions,
                historyPages: historyPages,
                bookmarkModels: bookmarkModels
            )
        } else {
            return mapToPresentableModel(
                searchSuggestions: [query],
                historyPages: historyPages,
                bookmarkModels: bookmarkModels
            )
        }
    }

    private func mapToPresentableModel(
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
