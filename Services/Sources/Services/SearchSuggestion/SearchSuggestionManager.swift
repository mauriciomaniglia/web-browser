import Foundation

@MainActor
public final class SearchSuggestionManager<S: SearchSuggestionServiceAPI, B: BookmarkStoreAPI, H: HistoryStoreAPI> {
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

    public func didStartTyping(query: String) async -> SearchSuggestionViewData {
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
        bookmarkModels: [BookmarkModel]) -> SearchSuggestionViewData
    {
        let searchSuggestionModels = searchSuggestions.map { suggestion in
            SearchSuggestionViewData.SearchSuggestion(
                title: suggestion,
                url: URLBuilderAPI.makeURL(from: suggestion)
            )
        }
        .prefix(10)
        .map { $0 }

        let historySuggestions = historyPages.compactMap { model in
            model.title.map { SearchSuggestionViewData.HistoryPage(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let bookmarkSuggestions = bookmarkModels.compactMap { model in
            model.title.map { SearchSuggestionViewData.Bookmark(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let model = SearchSuggestionViewData(
            bookmarkSuggestions: bookmarkSuggestions,
            historyPageSuggestions: historySuggestions,
            searchSuggestions: searchSuggestionModels
        )

        return model
    }
}

public struct SearchSuggestionViewData: Equatable {
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
