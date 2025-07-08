import XCTest
import Services

class SearchSuggestionPresenterTests: XCTestCase {

    func test_didLoad_deliversCorrectState() {
        let sut = makeSUT()
        var model: SearchSuggestionPresenter.Model!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didLoad(
            searchSuggestions: ["apple watch", "apple tv"],
            historyModels: [.init(title: "apple", url: URL(string: "https://www.apple.com")!, date: Date())],
            bookmarkModels: [.init(title: "apple magazine", url: URL(string: "https://www.apple-mag.com")!)]
        )

        XCTAssertEqual(model.searchSuggestions.first?.title, "apple watch")
        XCTAssertEqual(model.searchSuggestions.first?.url, URL(string: "https://www.google.com/search?q=apple%20watch&ie=utf-8&oe=utf-8")!)
        XCTAssertEqual(model.searchSuggestions.last?.title, "apple tv")
        XCTAssertEqual(model.searchSuggestions.last?.url, URL(string: "https://www.google.com/search?q=apple%20tv&ie=utf-8&oe=utf-8")!)
        XCTAssertEqual(model.historyPageSuggestions.first?.title, "apple")
        XCTAssertEqual(model.historyPageSuggestions.first?.url, URL(string: "https://www.apple.com")!)
        XCTAssertEqual(model.bookmarkSuggestions.first?.title, "apple magazine")
        XCTAssertEqual(model.bookmarkSuggestions.first?.url, URL(string: "https://www.apple-mag.com")!)

    }

    func test_didLoad_shouldDeliverOnlyTheTenFirstResults() {
        let sut = makeSUT()
        var model: SearchSuggestionPresenter.Model!
        let searchSuggestions = (1...12).map { "Serch Suggestion \($0)" }
        let historyPageModels = (1...12).map { makeHistoryModel(title: "History title \($0)") }
        let bookmarkModels = (1...12).map { makeBookmarkModel(title: "Bookmark title \($0)") }
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didLoad(
            searchSuggestions: searchSuggestions,
            historyModels: historyPageModels,
            bookmarkModels: bookmarkModels
        )

        XCTAssertEqual(model.searchSuggestions.count, 10)
        XCTAssertEqual(model.historyPageSuggestions.count, 10)
        XCTAssertEqual(model.bookmarkSuggestions.count, 10)
        XCTAssertEqual(model.searchSuggestions[0].title, "Serch Suggestion 1")
        XCTAssertEqual(model.searchSuggestions[1].title, "Serch Suggestion 2")
        XCTAssertEqual(model.searchSuggestions[2].title, "Serch Suggestion 3")
        XCTAssertEqual(model.searchSuggestions[3].title, "Serch Suggestion 4")
        XCTAssertEqual(model.searchSuggestions[4].title, "Serch Suggestion 5")
        XCTAssertEqual(model.searchSuggestions[5].title, "Serch Suggestion 6")
        XCTAssertEqual(model.searchSuggestions[6].title, "Serch Suggestion 7")
        XCTAssertEqual(model.searchSuggestions[7].title, "Serch Suggestion 8")
        XCTAssertEqual(model.searchSuggestions[8].title, "Serch Suggestion 9")
        XCTAssertEqual(model.searchSuggestions[9].title, "Serch Suggestion 10")
        XCTAssertEqual(model.historyPageSuggestions[0].title, "History title 1")
        XCTAssertEqual(model.historyPageSuggestions[1].title, "History title 2")
        XCTAssertEqual(model.historyPageSuggestions[2].title, "History title 3")
        XCTAssertEqual(model.historyPageSuggestions[3].title, "History title 4")
        XCTAssertEqual(model.historyPageSuggestions[4].title, "History title 5")
        XCTAssertEqual(model.historyPageSuggestions[5].title, "History title 6")
        XCTAssertEqual(model.historyPageSuggestions[6].title, "History title 7")
        XCTAssertEqual(model.historyPageSuggestions[7].title, "History title 8")
        XCTAssertEqual(model.historyPageSuggestions[8].title, "History title 9")
        XCTAssertEqual(model.historyPageSuggestions[9].title, "History title 10")
        XCTAssertEqual(model.bookmarkSuggestions[0].title, "Bookmark title 1")
        XCTAssertEqual(model.bookmarkSuggestions[1].title, "Bookmark title 2")
        XCTAssertEqual(model.bookmarkSuggestions[2].title, "Bookmark title 3")
        XCTAssertEqual(model.bookmarkSuggestions[3].title, "Bookmark title 4")
        XCTAssertEqual(model.bookmarkSuggestions[4].title, "Bookmark title 5")
        XCTAssertEqual(model.bookmarkSuggestions[5].title, "Bookmark title 6")
        XCTAssertEqual(model.bookmarkSuggestions[6].title, "Bookmark title 7")
        XCTAssertEqual(model.bookmarkSuggestions[7].title, "Bookmark title 8")
        XCTAssertEqual(model.bookmarkSuggestions[8].title, "Bookmark title 9")
        XCTAssertEqual(model.bookmarkSuggestions[9].title, "Bookmark title 10")

    }

    // MARK: - Helpers

    private func makeSUT() -> SearchSuggestionPresenter {
        return SearchSuggestionPresenter()
    }

    private func makeHistoryModel(title: String) -> HistoryPageModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!, date: Date())
    }

    private func makeBookmarkModel(title: String) -> BookmarkModel {
        .init(title: title, url: URL(string: "https://www.any-url.com")!)
    }
}
