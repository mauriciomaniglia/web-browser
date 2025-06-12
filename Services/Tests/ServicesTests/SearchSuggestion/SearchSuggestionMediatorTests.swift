import Foundation
import XCTest
@testable import Services

class SearchSuggestionMediatorTests: XCTestCase {

    func test_didStartTyping_whenThereIsNoSuggestion_deliversInputQuery() {
        let (sut, service, bookmarkStore, historyStore, presenter) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let history = HistoryPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [history]

        sut.didStartTyping(query: "apple")
        service.simulateResponseWithNoSuggestions()

        XCTAssertEqual(presenter.receivedMessages, [.didLoad(
            searchSuggestions: ["apple"],
            historyModels: [history],
            bookmarkModels: [bookmark]
        )])
    }

    func test_didStartTyping_whenThereIsSuggestion_deliversInputQueryAndSuggestions() {
        let (sut, service, bookmarkStore, historyStore, presenter) = makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        let history = HistoryPageModel(title: "Apple Music", url: URL(string: "https://www.apple-music.com")!, date: Date())
        bookmarkStore.mockBookmarks = [bookmark]
        historyStore.mockWebPages = [history]

        sut.didStartTyping(query: "apple")
        service.simulateResponseWithSuggestions(["apple watch", "apple tv", "apple music"])

        XCTAssertEqual(presenter.receivedMessages, [.didLoad(
            searchSuggestions: ["apple", "apple watch", "apple tv", "apple music"],
            historyModels: [history],
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

private class SearchSuggestionPresenterMock: SearchSuggestionPresenter {
    enum Message: Equatable {
        case didLoad(
            searchSuggestions: [String],
            historyModels: [HistoryPageModel],
            bookmarkModels: [BookmarkModel]
        )
    }

    var receivedMessages: [Message] = []

    override func didLoad(searchSuggestions: [String], historyModels: [HistoryPageModel], bookmarkModels: [BookmarkModel]) {
        receivedMessages.append(.didLoad(
            searchSuggestions: searchSuggestions,
            historyModels: historyModels,
            bookmarkModels: bookmarkModels
        ))
    }
}
