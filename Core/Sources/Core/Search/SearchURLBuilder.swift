import Foundation

public final class SearchURLBuilder {

    public static func makeURL(from text: String) -> URL {
        if let url = URIFixup.getURL(text) {
            return url
        } else {
            return SearchEngineURLBuilder.buildURL(fromTerm: text)
        }
    }
}
