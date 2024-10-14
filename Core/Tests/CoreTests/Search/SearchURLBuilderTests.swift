import Foundation
import XCTest
import Core

class SearchURLBuilderTests: XCTestCase {
    func test_makeURL_withCorrectURLText_deliversURL() {
        let url = SearchURLBuilder.makeURL(from: "https://apple.com")
        
        XCTAssertEqual(url.absoluteString, "https://apple.com")
    }
    
    func test_makeURL_withoutURLText_deliversSearchEngineURL() {
        let url = SearchURLBuilder.makeURL(from: "apple")
        
        XCTAssertEqual(url.absoluteString, "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")
    }
}
