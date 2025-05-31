import Foundation

protocol SearchSuggestionAPIContract {
    func getSuggestions(from text: String, callback: @escaping ([String]) -> Void)
}

public final class SearchSuggestionAPI: SearchSuggestionAPIContract {
    let searchSuggestionService: SearchSuggestionServiceContract

    init(searchSuggestionService: SearchSuggestionServiceContract) {
        self.searchSuggestionService = searchSuggestionService
    }

    public func getSuggestions(from text: String, callback: @escaping ([String]) -> Void) {
        let url = SearchEngineURLBuilder.buildAutocompleteURL(query: text)

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
