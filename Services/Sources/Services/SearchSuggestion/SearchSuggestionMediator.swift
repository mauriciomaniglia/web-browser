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

    public func getSuggestions(from text: String) {
        let url = SearchEngineURLBuilder.buildAutocompleteURL(query: text)

        let bookmarkModels = bookmarkStore.getPages(by: text)
        let historyPageModels = historyStore.getPages(by: text)

        searchSuggestionService.query(url) { [weak self] suggestions in
            if var suggestions {
                suggestions.insert(text, at: 0)
                self?.presenter.didLoad(
                    searchSuggestions: suggestions,
                    historyModels: historyPageModels,
                    bookmarkModels: bookmarkModels
                )
            } else {
                self?.presenter.didLoad(
                    searchSuggestions: [text],
                    historyModels: historyPageModels,
                    bookmarkModels: bookmarkModels
                )
            }
        }
    }
}
