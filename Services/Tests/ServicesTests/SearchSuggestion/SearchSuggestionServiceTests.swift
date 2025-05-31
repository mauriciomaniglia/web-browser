import XCTest
@testable import Services

class SearchSuggestionServiceTests: XCTestCase {
    func test_handleResponse_whenDataIsEmpty_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: nil, response: HTTPURLResponse(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenDataIsInvalidJSON_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }
        let invalidJSONData = "".data(using: .utf8)!

        sut.handleResponse(data: invalidJSONData, response: HTTPURLResponse(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenJSONHasMissingQueryData_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: invalidSearchResponseMissingQueryData(), response: HTTPURLResponse(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenJSONHasInvalidSearchSuggestionTypeData_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: invalidSearchSuggestionsTypeData(), response: HTTPURLResponse(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenIsNonHTTPResponse_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: validData(), response: URLResponse(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenHTTPResponseIsNot2xx_returnsNil() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: validData(), response: httpResponseWith500StatusCode(), callback)

        XCTAssertNil(receivedSuggestions)
    }

    func test_handleResponse_whenResponseHasCorrectData_returnSuggestions() {
        let sut = SearchSuggestionService()
        var receivedSuggestions: [String]?
        let callback: SearchSuggestionService.SearchSuggestionResponse = { suggestions in
            receivedSuggestions = suggestions
        }

        sut.handleResponse(data: validData(), response: HTTPURLResponse(), callback)

        XCTAssertEqual(receivedSuggestions, ["suggestion1", "suggestion2", "suggestion3"])
    }

    // MARK: - Helpers

    private func httpResponseWith500StatusCode() -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://example.com")!,
                               statusCode: 500,
                               httpVersion: nil,
                               headerFields: nil)!
    }

    private func validData() -> Data {
        let jsonString = """
        ["query", ["suggestion1", "suggestion2", "suggestion3"]]
        """
        return jsonString.data(using: .utf8)!
    }

    private func invalidSearchResponseMissingQueryData() -> Data {
        let jsonString = """
        [["suggestion1", "suggestion2", "suggestion3"]]
        """
        return jsonString.data(using: .utf8)!
    }

    private func invalidSearchSuggestionsTypeData() -> Data {
        let jsonString = """
        ["query", [1, 2, 3]]
        """
        return jsonString.data(using: .utf8)!
    }
}

