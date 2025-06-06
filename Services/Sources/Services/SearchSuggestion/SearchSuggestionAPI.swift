import Foundation

public final class SearchSuggestionAPI {
    let searchSuggestionService: SearchSuggestionServiceContract
    let bookmarkStore: BookmarkStoreAPI
    let historyStore: HistoryStoreAPI

    init(searchSuggestionService: SearchSuggestionServiceContract, bookmarkStore: BookmarkStoreAPI, historyStore: HistoryStoreAPI) {
        self.searchSuggestionService = searchSuggestionService
        self.bookmarkStore = bookmarkStore
        self.historyStore = historyStore
    }

    public func getSuggestions(from text: String, callback: @escaping ([String]) -> Void) {
        let url = SearchEngineURLBuilder.buildAutocompleteURL(query: text)

        let bookmarkModels = bookmarkStore.getPages(by: text)
        let historyPageModels = historyStore.getPages(by: text)

        searchSuggestionService.query(url) { suggestions in
            if var suggestions {
                suggestions.insert(text, at: 0)
                callback(suggestions)
            } else {
                callback([text])
            }
        }
    }
}
