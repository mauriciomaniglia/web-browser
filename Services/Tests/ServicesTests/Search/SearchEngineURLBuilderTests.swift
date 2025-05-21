import XCTest
import Services

class SearchEngineURLBuilderTests: XCTestCase {
    func test_buildSearchURL_deliversCorrectURL() {
        let url1 = SearchEngineURLBuilder.buildSearchURL(query: "computer")
        let url2 = SearchEngineURLBuilder.buildSearchURL(query: "computer science")

        XCTAssertEqual(url1.absoluteString, "https://www.google.com/search?q=computer&ie=utf-8&oe=utf-8")
        XCTAssertEqual(url2.absoluteString, "https://www.google.com/search?q=computer%20science&ie=utf-8&oe=utf-8")
    }
}

