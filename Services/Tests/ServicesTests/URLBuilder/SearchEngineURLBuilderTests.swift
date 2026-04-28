import Testing
import Services

@MainActor
@Suite
struct SearchEngineURLBuilderTests {
    @Test("Builds correct Google search URLs with and without spaces")
    func buildSearchURL_returnsExpectedURLs() {
        let url1 = SearchEngineURLBuilder.buildSearchURL(query: "computer")
        let url2 = SearchEngineURLBuilder.buildSearchURL(query: "computer science")

        #expect(url1.absoluteString == "https://www.google.com/search?q=computer&ie=utf-8&oe=utf-8")
        #expect(url2.absoluteString == "https://www.google.com/search?q=computer%20science&ie=utf-8&oe=utf-8")
    }

    @Test("Builds correct Google autocomplete URLs with and without spaces")
    func buildAutocompleteURL_returnsExpectedURLs() {
        let url1 = SearchEngineURLBuilder.buildAutocompleteURL(query: "computer")
        let url2 = SearchEngineURLBuilder.buildAutocompleteURL(query: "computer science")

        #expect(url1.absoluteString == "https://www.google.com/complete/search?client=firefox&q=computer")
        #expect(url2.absoluteString == "https://www.google.com/complete/search?client=firefox&q=computer%20science")
    }
}
