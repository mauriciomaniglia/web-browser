import Foundation

public final class SearchEngineURLBuilder {
    public static func buildURL(fromTerm query: String) -> URL {
        let searchTemplate = "https://www.google.com/search?q={searchTerms}&ie=utf-8&oe=utf-8"
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .searchTermsAllowed)!
        
        let templateAllowedSet = NSMutableCharacterSet()
        templateAllowedSet.formUnion(with: .URLAllowed)
        templateAllowedSet.formUnion(with: CharacterSet(charactersIn: "{}"))

        let encodedSearchTemplate = searchTemplate.addingPercentEncoding(withAllowedCharacters: templateAllowedSet as CharacterSet)!
        let urlString = encodedSearchTemplate.replacingOccurrences(of: "{searchTerms}", with: escapedQuery, options: .literal, range: nil)

        return URL(string: urlString)!
    }
}
