import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct URLBuilderAPITests {
    @Test("Returns the same URL when input is a valid URL")
    func makeURL_withValidURLText_returnsURL() {
        let url = URLBuilderAPI.makeURL(from: "https://apple.com")

        #expect(url.absoluteString == "https://apple.com")
    }
    
    @Test("Builds a Google search URL when input is plain text")
    func makeURL_withPlainText_returnsSearchEngineURL() {
        let url = URLBuilderAPI.makeURL(from: "apple")

        #expect(url.absoluteString == "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")
    }
}
