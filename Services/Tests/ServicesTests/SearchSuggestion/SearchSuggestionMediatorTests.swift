import Foundation
import XCTest
@testable import Services

class SearchSuggestionMediatorTests: XCTestCase {

    func test_didStartTyping_whenThereIsNoSuggestion_deliversInputQuery() async {
        let (sut, service, bookmarkStore, historyStore) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]
        service.mockSuggestions = []

        let presentableModel = await sut.didStartTyping(query: "apple")

        XCTAssertEqual(presentableModel.searchSuggestions, [.init(title: "apple", url: URL(string: "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")!)])
        XCTAssertEqual(presentableModel.bookmarkSuggestions, [.init(title: "Apple Store", url: URL(string: "https://www.apple.com")!)])
        XCTAssertEqual(presentableModel.historyPageSuggestions, [.init(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!)])
    }

    func test_didStartTyping_whenThereIsSuggestion_deliversInputQueryAndSuggestions() async {
        let (sut, service, bookmarkStore, historyStore) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]
        service.mockSuggestions = ["apple watch", "apple tv", "apple music"]

        let presentableModel = await sut.didStartTyping(query: "apple")

        XCTAssertEqual(presentableModel.searchSuggestions, [
            .init(title: "apple", url: URL(string: "https://www.google.com/search?q=apple&ie=utf-8&oe=utf-8")!),
            .init(title: "apple watch", url: URL(string: "https://www.google.com/search?q=apple%20watch&ie=utf-8&oe=utf-8")!),
            .init(title: "apple tv", url: URL(string: "https://www.google.com/search?q=apple%20tv&ie=utf-8&oe=utf-8")!),
            .init(title: "apple music", url: URL(string: "https://www.google.com/search?q=apple%20music&ie=utf-8&oe=utf-8")!)
        ])
        XCTAssertEqual(presentableModel.bookmarkSuggestions, [.init(title: "Apple Store", url: URL(string: "https://www.apple.com")!)])
        XCTAssertEqual(presentableModel.historyPageSuggestions, [.init(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!)])
     }

    // MARK: - Helpers

    private func makeSUT() -> (SearchSuggestionMediator, MockSearchSuggestionService, BookmarkStoreMock, HistoryStoreMock) {
        let searchSuggestionService = MockSearchSuggestionService()
        let bookmarkStore = BookmarkStoreMock()
        let historyStore = HistoryStoreMock()
        let presenter = SearchSuggestionPresenter()

        let sut = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )

        return (sut, searchSuggestionService, bookmarkStore, historyStore)
    }

    private class MockSearchSuggestionService: SearchSuggestionServiceContract {
        var mockSuggestions = [String]()

        func query(_ url: URL) async throws -> [String]? {
            mockSuggestions
        }
    }
}
