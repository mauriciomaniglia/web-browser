import Foundation
import XCTest
@testable import Services

class SearchAPITests: XCTestCase {
    func test_makeURL_withCorrectURLText_deliversURL() {
        let url = SearchAPI.makeURL(from: "https://apple.com")

        XCTAssertEqual(url.absoluteString, "https://apple.com")
    }
    
    func test_makeURL_withoutURLText_deliversSearchEngineURL() {
        let url = SearchAPI.makeURL(from: "apple")

        XCTAssertEqual(url.absoluteString, "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")
    }

    func test_getSuggestion_whenThereIsNoSuggestion_deliversInputQuery() {
        let service = MockSearchSuggestionService()
        let sut = SearchAPI(searchSuggestionService: service)
        var receivedSuggestions: [String]?

        sut.getSuggestions(from: "apple") { suggestions in
            receivedSuggestions = suggestions
        }
        service.simulateResponseWithNoSuggestions()

        XCTAssertEqual(receivedSuggestions, ["apple"])
    }

    func test_getSuggestion_whenThereIsSuggestion_deliversInputQueryAndSuggestions() {
        let service = MockSearchSuggestionService()
        let sut = SearchAPI(searchSuggestionService: service)
        var receivedSuggestions: [String]?

        sut.getSuggestions(from: "apple") { suggestions in
            receivedSuggestions = suggestions
        }
        service.simulateResponseWithSuggestions(["apple watch", "apple tv", "apple music"])

        XCTAssertEqual(receivedSuggestions, ["apple", "apple watch", "apple tv", "apple music"])
    }
}

private class MockSearchSuggestionService: SearchSuggestionServiceContract {
    var receivedCallback: SearchSuggestionService.SearchSuggestionResponse?

    func query(_ url: URL, callback: @escaping SearchSuggestionService.SearchSuggestionResponse) {
        receivedCallback = callback
    }

    func simulateResponseWithNoSuggestions() {
        receivedCallback?(nil)
    }

    func simulateResponseWithSuggestions(_ suggestions: [String]) {
        receivedCallback?(suggestions)
    }
}
