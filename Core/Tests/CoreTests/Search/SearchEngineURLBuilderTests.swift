import XCTest
import Core

class SearchEngineURLBuilderTests: XCTestCase {
    func test_buildURLFromTerm_deliversCorrectURL() {
        let url1 = SearchEngineURLBuilder.buildURL(fromTerm: "computer")
        let url2 = SearchEngineURLBuilder.buildURL(fromTerm: "computer science")
        
        XCTAssertEqual(url1.absoluteString, "https://www.google.com/search?q=computer&ie=utf-8&oe=utf-8")
        XCTAssertEqual(url2.absoluteString, "https://www.google.com/search?q=computer%20science&ie=utf-8&oe=utf-8")
    }
}

