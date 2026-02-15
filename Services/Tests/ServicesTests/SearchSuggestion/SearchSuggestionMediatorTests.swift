import Foundation
import XCTest
@testable import Services

class SearchSuggestionMediatorTests: XCTestCase {

    func test_didStartTyping_whenThereIsNoSuggestion_deliversInputQuery() async {
        let (sut, service, bookmarkStore, historyStore, presenter) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]

        await sut.didStartTyping(query: "apple")
        service.mockSuggestions = []

        XCTAssertEqual(presenter.receivedMessages, [.didLoad(
            searchSuggestions: ["apple"],
            historyPages: [page],
            bookmarkModels: [bookmark]
        )])
    }

    func test_didStartTyping_whenThereIsSuggestion_deliversInputQueryAndSuggestions() async {
        let (sut, service, bookmarkStore, historyStore, presenter) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let page = WebPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [page]
        service.mockSuggestions = ["apple watch", "apple tv", "apple music"]

        await sut.didStartTyping(query: "apple")

        XCTAssertEqual(presenter.receivedMessages, [.didLoad(
            searchSuggestions: ["apple", "apple watch", "apple tv", "apple music"],
            historyPages: [page],
            bookmarkModels: [bookmark]
        )])
    }

    // MARK: - Helpers

    private func makeSUT() -> (SearchSuggestionMediator, MockSearchSuggestionService, BookmarkStoreMock, HistoryStoreMock, SearchSuggestionPresenterMock) {
        let searchSuggestionService = MockSearchSuggestionService()
        let bookmarkStore = BookmarkStoreMock()
        let historyStore = HistoryStoreMock()
        let presenter = SearchSuggestionPresenterMock()

        let sut = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )

        return (sut, searchSuggestionService, bookmarkStore, historyStore, presenter)
    }
}

private class MockSearchSuggestionService: SearchSuggestionServiceContract {
    var mockSuggestions = [String]()

    func query(_ url: URL) async throws -> [String]? {
        mockSuggestions
    }
}

private class SearchSuggestionPresenterMock: SearchSuggestionPresenter {
    enum Message: Equatable {
        case didLoad(
            searchSuggestions: [String],
            historyPages: [WebPageModel],
            bookmarkModels: [BookmarkModel]
        )
    }

    var receivedMessages: [Message] = []

    override func didLoad(searchSuggestions: [String], historyPages: [WebPageModel], bookmarkModels: [BookmarkModel]) {
        receivedMessages.append(.didLoad(
            searchSuggestions: searchSuggestions,
            historyPages: historyPages,
            bookmarkModels: bookmarkModels
        ))
    }
}
