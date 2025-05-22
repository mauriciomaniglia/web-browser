import Foundation

public final class SearchEngineURLBuilder {
    public static func buildSearchURL(query: String) -> URL {
        let searchTemplate = "https://www.google.com/search?q={searchTerms}&ie=utf-8&oe=utf-8"
        return buildURL(searchTemplate: searchTemplate, query: query)
    }

    public static func buildAutocompleteURL(query: String) -> URL {
        let searchTemplate = "https://www.google.com/complete/search?client=firefox&q={searchTerms}"
        return buildURL(searchTemplate: searchTemplate, query: query)
    }

    private static func buildURL(searchTemplate: String, query: String) -> URL {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .searchTermsAllowed)!

        let templateAllowedSet = NSMutableCharacterSet()
        templateAllowedSet.formUnion(with: .URLAllowed)
        templateAllowedSet.formUnion(with: CharacterSet(charactersIn: "{}"))

        let encodedSearchTemplate = searchTemplate.addingPercentEncoding(withAllowedCharacters: templateAllowedSet as CharacterSet)!
        let urlString = encodedSearchTemplate.replacingOccurrences(of: "{searchTerms}", with: escapedQuery, options: .literal, range: nil)

        return URL(string: urlString)!
    }
}
