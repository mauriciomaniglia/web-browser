import XCTest
@testable import Services

class SearchSuggestionPresenterTests: XCTestCase {

    func test_didLoad_deliversCorrectState() {
        let (sut, delegate) = makeSUT()
        let expectedModel = SearchSuggestionPresenter.Model(
            bookmarkSuggestions: [.init(title: "apple magazine", url: URL(string: "https://www.apple-mag.com")!)],
            historyPageSuggestions: [.init(title: "apple", url: URL(string: "https://www.apple.com")!)],
            searchSuggestions: [.init(title: "apple watch", url: makeSearchURL(from: "apple watch")),
                                .init(title: "apple tv", url: makeSearchURL(from: "apple tv"))]
        )

        sut.didLoad(
            searchSuggestions: ["apple watch", "apple tv"],
            historyModels: [.init(title: "apple", url: URL(string: "https://www.apple.com")!, date: Date())],
            bookmarkModels: [.init(title: "apple magazine", url: URL(string: "https://www.apple-mag.com")!)]
        )

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel(expectedModel)])

    }

    func test_didLoad_shouldDeliverOnlyTheTenFirstResults() {
        let (sut, delegate) = makeSUT()
        let searchSuggestions = (1...15).map { "Search \($0)" }
        let historyPageModels = (1...15).map { makeHistoryModel(title: "History title \($0)") }
        let bookmarkModels = (1...15).map { makeBookmarkModel(title: "Bookmark title \($0)") }
        let expectedModel = SearchSuggestionPresenter.Model(
            bookmarkSuggestions: Array(bookmarkModels.prefix(10).map { .init(title: $0.title ?? "", url: $0.url)}),
            historyPageSuggestions: Array(historyPageModels.prefix(10).map { .init(title: $0.title ?? "", url: $0.url)}),
            searchSuggestions: Array(searchSuggestions.prefix(10).map { .init(title: $0, url: makeSearchURL(from: $0))})
        )

        sut.didLoad(
            searchSuggestions: searchSuggestions,
            historyModels: historyPageModels,
            bookmarkModels: bookmarkModels
        )

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel(expectedModel)])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: SearchSuggestionPresenter, delegate: SearchSuggestionPresenterDelegateMock) {
        let delegate = SearchSuggestionPresenterDelegateMock()
        let sut = SearchSuggestionPresenter()
        sut.delegate = delegate

        return (sut, delegate)
    }

    private func makeHistoryModel(title: String) -> HistoryPageModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!, date: Date())
    }

    private func makeBookmarkModel(title: String) -> BookmarkModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!)
    }

    private func makeSearchURL(from text: String) -> URL {
        URL(string: "https://www.google.com/search?q=\(text)&ie=utf-8&oe=utf-8")!
    }
}

private class SearchSuggestionPresenterDelegateMock: SearchSuggestionPresenterDelegate {
    enum Message: Equatable {
        case didUpdatePresentableModel(_ model: SearchSuggestionPresenter.Model)
    }

    var receivedMessages = [Message]()

    func didUpdatePresentableModel(_ model: SearchSuggestionPresenter.Model) {
        receivedMessages.append(.didUpdatePresentableModel(model))
    }
}
