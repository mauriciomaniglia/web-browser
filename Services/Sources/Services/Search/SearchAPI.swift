import Foundation

protocol SearchAPIContract {
    static func makeURL(from text: String) -> URL
    func getSuggestions(from text: String, callback: @escaping ([String]) -> Void)
}

public final class SearchAPI: SearchAPIContract {

    let searchSuggestionService: SearchSuggestionServiceContract

    init(searchSuggestionService: SearchSuggestionServiceContract) {
        self.searchSuggestionService = searchSuggestionService
    }

    public static func makeURL(from text: String) -> URL {
        if let url = URIFixup.getURL(text) {
            return url
        } else {
            return SearchEngineURLBuilder.buildSearchURL(query: text)
        }
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
