import XCTest
@testable import Services

class SearchAutocompleteServiceTests: XCTestCase {
    func test_handleResponse_whenDataIsEmpty_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: nil, response: HTTPURLResponse(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenDataIsInvalidJSON_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }
        let invalidJSONData = "".data(using: .utf8)!

        sut.handleResponse(data: invalidJSONData, response: HTTPURLResponse(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenJSONHasMissingQueryData_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: invalidSearchResponseMissingQueryData(), response: HTTPURLResponse(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenJSONHasInvalidSearchSuggestionTypeData_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: invalidSearchSuggestionsTypeData(), response: HTTPURLResponse(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenIsNonHTTPResponse_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: validData(), response: URLResponse(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenHTTPResponseIsNot2xx_returnsError() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: validData(), response: httpResponseWith500StatusCode(), error: nil, callback)

        XCTAssertNil(receivedResponse.suggestion)
        XCTAssertEqual(receivedResponse.error, searchSuggestError())
    }

    func test_handleResponse_whenResponseHasCorrectData_returnCorrectSuggestions() {
        let sut = SearchAutocompleteService()
        var receivedResponse: (suggestion: [String]?, error: NSError?)
        let callback: SearchAutocompleteService.SearchAutocompleteResponse = { suggestions, error in
            receivedResponse = (suggestions, error)
        }

        sut.handleResponse(data: validData(), response: HTTPURLResponse(), error: nil, callback)

        XCTAssertEqual(receivedResponse.suggestion, ["suggestion1", "suggestion2", "suggestion3"])
        XCTAssertNil(receivedResponse.error)
    }

    // MARK: - Helpers

    private func httpResponseWith500StatusCode() -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://example.com")!,
                               statusCode: 500,
                               httpVersion: nil,
                               headerFields: nil)!
    }

    private func searchSuggestError() -> NSError {
        NSError(domain: "SearchSuggestClient", code: 1, userInfo: nil)
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

