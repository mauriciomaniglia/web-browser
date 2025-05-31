import Foundation
import XCTest
@testable import Services

class SearchSuggestionAPITests: XCTestCase {

    func test_getSuggestion_whenThereIsNoSuggestion_deliversInputQuery() {
        let service = MockSearchSuggestionService()
        let sut = SearchSuggestionAPI(searchSuggestionService: service)
        var receivedSuggestions: [String]?

        sut.getSuggestions(from: "apple") { suggestions in
            receivedSuggestions = suggestions
        }
        service.simulateResponseWithNoSuggestions()

        XCTAssertEqual(receivedSuggestions, ["apple"])
    }

    func test_getSuggestion_whenThereIsSuggestion_deliversInputQueryAndSuggestions() {
        let service = MockSearchSuggestionService()
        let sut = SearchSuggestionAPI(searchSuggestionService: service)
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
