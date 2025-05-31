import Foundation

public final class URLBuilderAPI {

    public static func makeURL(from text: String) -> URL {
        if let url = URIFixup.getURL(text) {
            return url
        } else {
            return SearchEngineURLBuilder.buildSearchURL(query: text)
        }
    }
}
