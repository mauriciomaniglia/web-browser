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

    public func didStartTyping(query: String) {
        let queryURL = SearchEngineURLBuilder.buildAutocompleteURL(query: query)
        let bookmarkModels = bookmarkStore.getPages(by: query)
        let historyPageModels = historyStore.getPages(by: query)

        searchSuggestionService.query(queryURL) { [weak self] suggestions in
            if var suggestions {
                suggestions.insert(query, at: 0)
                self?.presenter.didLoad(
                    searchSuggestions: suggestions,
                    historyModels: historyPageModels,
                    bookmarkModels: bookmarkModels
                )
            } else {
                self?.presenter.didLoad(
                    searchSuggestions: [query],
                    historyModels: historyPageModels,
                    bookmarkModels: bookmarkModels
                )
            }
        }
    }
}
