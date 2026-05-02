import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct SearchSuggestionManagerTests {
    private typealias SearchSuggestionManagerType = SearchSuggestionManager<MockSearchSuggestionService, BookmarkStoreMock, HistoryStoreMock>

    @Test("Typing with no remote suggestions returns query + local suggestions")
    func didStartTyping_whenThereIsNoSuggestion_deliversInputQuery() async {
        let (sut, bookmarkStore, historyStore) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]

        let presentableModel = await sut.didStartTyping(query: "apple")

        #expect(presentableModel.searchSuggestions == [.init(title: "apple", url: URL(string: "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")!)])
        #expect(presentableModel.bookmarkSuggestions == [.init(title: "Apple Store", url: URL(string: "https://www.apple.com")!)])
        #expect(presentableModel.historyPageSuggestions == [.init(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!)])
    }

    @Test("Typing with remote suggestions returns query + remote + local suggestions")
    func didStartTyping_whenThereIsSuggestion_deliversInputQueryAndSuggestions() async {
        let (sut, bookmarkStore, historyStore) = makeSUT(searchSuggestion: ["apple watch", "apple tv", "apple music"])
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]

        let presentableModel = await sut.didStartTyping(query: "apple")

        #expect(presentableModel.searchSuggestions == [
            .init(title: "apple", url: URL(string: "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")!),
            .init(title: "apple watch", url: URL(string: "https://www.google.com/search?q=apple%20watch&ie=utf-8&oe=utf-8")!),
            .init(title: "apple tv", url: URL(string: "https://www.google.com/search?q=apple%20tv&ie=utf-8&oe=utf-8")!),
            .init(title: "apple music", url: URL(string: "https://www.google.com/search?q=apple%20music&ie=utf-8&oe=utf-8")!)
        ])
        #expect(presentableModel.bookmarkSuggestions == [.init(title: "Apple Store", url: URL(string: "https://www.apple.com")!)])
        #expect(presentableModel.historyPageSuggestions == [.init(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!)])
     }

    // MARK: - Helpers

    private func makeSUT(searchSuggestion: [String] = []) -> (SearchSuggestionManagerType, BookmarkStoreMock, HistoryStoreMock) {
        let searchSuggestionService = MockSearchSuggestionService(mockSuggestions: searchSuggestion)
        let bookmarkStore = BookmarkStoreMock()
        let historyStore = HistoryStoreMock()

        let sut = SearchSuggestionManager(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore
        )

        return (sut, bookmarkStore, historyStore)
    }

    private final class MockSearchSuggestionService: SearchSuggestionServiceAPI {
        let mockSuggestions: [String]

        init(mockSuggestions: [String]) {
            self.mockSuggestions = mockSuggestions
        }

        func query(_ url: URL) async throws -> [String]? {
            mockSuggestions
        }
    }
}
