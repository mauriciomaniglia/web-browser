import Foundation
import XCTest
import Services

class SearchAPITests: XCTestCase {
    func test_makeURL_withCorrectURLText_deliversURL() {
        let url = SearchAPI.makeURL(from: "https://apple.com")

        XCTAssertEqual(url.absoluteString, "https://apple.com")
    }
    
    func test_makeURL_withoutURLText_deliversSearchEngineURL() {
        let url = SearchAPI.makeURL(from: "apple")

        XCTAssertEqual(url.absoluteString, "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")
    }
}
