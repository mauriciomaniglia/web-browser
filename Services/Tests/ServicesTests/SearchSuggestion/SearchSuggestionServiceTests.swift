import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct SearchSuggestionServiceTests {
    @Test("Returns nil when data is nil")
    func returnsNilWhenDataIsNil() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: nil, response: HTTPURLResponse())

        #expect(suggestions == nil)
    }

    @Test("Returns nil for invalid JSON data")
    func returnsNilForInvalidJSONData() {
        let sut = SearchSuggestionService()
        let invalidJSONData = "".data(using: .utf8)!

        let suggestions = sut.handleResponse(data: invalidJSONData, response: HTTPURLResponse())

        #expect(suggestions == nil)
    }

    @Test("Returns nil when query data is missing in JSON")
    func returnsNilWhenQueryDataIsMissingInJSON() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: invalidSearchResponseMissingQueryData(), response: HTTPURLResponse())

        #expect(suggestions == nil)
    }

    @Test("Returns nil when suggestions are not strings")
    func returnsNilWhenSuggestionsAreNotStrings() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: invalidSearchSuggestionsTypeData(), response: HTTPURLResponse())

        #expect(suggestions == nil)
    }

    @Test("Returns nil for non-HTTPURLResponse")
    func returnsNilForNonHTTPURLResponse() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: URLResponse())

        #expect(suggestions == nil)
    }

    @Test("Returns nil for non-2xx HTTP status codes")
    func returnsNilForNon2xxHTTPStatusCodes() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: httpResponseWith500StatusCode())

        #expect(suggestions == nil)
    }

    @Test("Parses and returns suggestions from valid response")
    func parsesAndReturnsSuggestionsFromValidResponse() {
        let sut = SearchSuggestionService()

        let suggestions = sut.handleResponse(data: validData(), response: HTTPURLResponse())

        #expect(suggestions == ["suggestion1", "suggestion2", "suggestion3"])
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
