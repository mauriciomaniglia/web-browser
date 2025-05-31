import Foundation
import XCTest
@testable import Services

class URLBuilderAPITests: XCTestCase {
    func test_makeURL_withCorrectURLText_deliversURL() {
        let url = URLBuilderAPI.makeURL(from: "https://apple.com")

        XCTAssertEqual(url.absoluteString, "https://apple.com")
    }
    
    func test_makeURL_withoutURLText_deliversSearchEngineURL() {
        let url = URLBuilderAPI.makeURL(from: "apple")

        XCTAssertEqual(url.absoluteString, "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")
    }
}
