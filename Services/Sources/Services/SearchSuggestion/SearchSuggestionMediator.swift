import Foundation

public final class SearchSuggestionMediator {
    let searchSuggestionService: SearchSuggestionServiceContract
    let bookmarkStore: BookmarkStoreAPI
    let historyStore: HistoryStoreAPI
    let presenter: SearchSuggestionPresenter

    public init(
        searchSuggestionService: SearchSuggestionServiceContract,
        bookmarkStore: BookmarkStoreAPI,
        historyStore: HistoryStoreAPI,
        presenter: SearchSuggestionPresenter
    ) {
        self.searchSuggestionService = searchSuggestionService
        self.bookmarkStore = bookmarkStore
        self.historyStore = historyStore
        self.presenter = presenter
    }

    public func didStartTyping(query: String) async -> PresentableSearchSuggestion {
        let queryURL = SearchEngineURLBuilder.buildAutocompleteURL(query: query)
        let bookmarkModels = bookmarkStore.getPages(by: query)
        let historyPages = historyStore.getPages(by: query)

        if var suggestions = try? await searchSuggestionService.query(queryURL) {
            suggestions.insert(query, at: 0)
            return presenter.didLoad(
                searchSuggestions: suggestions,
                historyPages: historyPages,
                bookmarkModels: bookmarkModels
            )
        } else {
            return presenter.didLoad(
                searchSuggestions: [query],
                historyPages: historyPages,
                bookmarkModels: bookmarkModels
            )
        }
    }
}
