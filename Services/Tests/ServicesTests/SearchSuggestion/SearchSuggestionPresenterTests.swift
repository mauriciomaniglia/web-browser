import XCTest
@testable import Services

class SearchSuggestionPresenterTests: XCTestCase {

    func test_didLoad_deliversCorrectState() {
        let sut = SearchSuggestionPresenter()
        let expectedModel = PresentableSearchSuggestion(
            bookmarkSuggestions: [.init(title: "apple magazine", url: URL(string: "https://www.apple-mag.com")!)],
            historyPageSuggestions: [.init(title: "apple", url: URL(string: "https://www.apple.com")!)],
            searchSuggestions: [.init(title: "apple watch", url: makeSearchURL(from: "apple watch")),
                                .init(title: "apple tv", url: makeSearchURL(from: "apple tv"))]
        )

        let presentableModel = sut.didLoad(
            searchSuggestions: ["apple watch", "apple tv"],
            historyPages: [.init(title: "apple", url: URL(string: "https://www.apple.com")!, date: Date())],
            bookmarkModels: [.init(title: "apple magazine", url: URL(string: "https://www.apple-mag.com")!)]
        )

        XCTAssertEqual(presentableModel, expectedModel)

    }

    func test_didLoad_shouldDeliverOnlyTheTenFirstResults() {
        let sut = SearchSuggestionPresenter()
        let searchSuggestions = (1...15).map { "Search \($0)" }
        let historyPageModels = (1...15).map { makeHistoryModel(title: "History title \($0)") }
        let bookmarkModels = (1...15).map { makeBookmarkModel(title: "Bookmark title \($0)") }
        let expectedModel = PresentableSearchSuggestion(
            bookmarkSuggestions: Array(bookmarkModels.prefix(10).map { .init(title: $0.title ?? "", url: $0.url)}),
            historyPageSuggestions: Array(historyPageModels.prefix(10).map { .init(title: $0.title ?? "", url: $0.url)}),
            searchSuggestions: Array(searchSuggestions.prefix(10).map { .init(title: $0, url: makeSearchURL(from: $0))})
        )

        let presentableModel = sut.didLoad(
            searchSuggestions: searchSuggestions,
            historyPages: historyPageModels,
            bookmarkModels: bookmarkModels
        )

        XCTAssertEqual(presentableModel, expectedModel)
    }

    // MARK: - Helpers

    private func makeHistoryModel(title: String) -> WebPageModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!, date: Date())
    }

    private func makeBookmarkModel(title: String) -> BookmarkModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!)
    }

    private func makeSearchURL(from text: String) -> URL {
        URL(string: "https://www.google.com/search?q=\(text)&ie=utf-8&oe=utf-8")!
    }
}
