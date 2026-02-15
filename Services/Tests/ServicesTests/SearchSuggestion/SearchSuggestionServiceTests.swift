import XCTest
@testable import Services

class SearchSuggestionServiceTests: XCTestCase {
    func test_handleResponse_whenDataIsEmpty_returnsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: nil, response: HTTPURLResponse())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenDataIsInvalidJSON_returnsNil() {
        let sut = SearchSuggestionService()
        let invalidJSONData = "".data(using: .utf8)!

        let suggestions = sut.handleResponse(data: invalidJSONData, response: HTTPURLResponse())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenJSONHasMissingQueryData_returnsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: invalidSearchResponseMissingQueryData(), response: HTTPURLResponse())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenJSONHasInvalidSearchSuggestionTypeData_returnsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: invalidSearchSuggestionsTypeData(), response: HTTPURLResponse())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenIsNonHTTPResponse_returnsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: URLResponse())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenHTTPResponseIsNot2xx_returnsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: httpResponseWith500StatusCode())

        XCTAssertNil(suggestions)
    }

    func test_handleResponse_whenResponseHasCorrectData_returnSuggestions() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: HTTPURLResponse())

        XCTAssertEqual(suggestions, ["suggestion1", "suggestion2", "suggestion3"])
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

