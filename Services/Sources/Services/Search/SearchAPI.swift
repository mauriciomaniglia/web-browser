import Foundation

protocol SearchAPIContract {
    static func makeURL(from text: String) -> URL
}

public final class SearchAPI: SearchAPIContract {

    public static func makeURL(from text: String) -> URL {
        if let url = URIFixup.getURL(text) {
            return url
        } else {
            return SearchEngineURLBuilder.buildSearchURL(query: text)
        }
    }
}
