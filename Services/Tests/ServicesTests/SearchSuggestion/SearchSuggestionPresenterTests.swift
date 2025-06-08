import XCTest
import Services

class SearchSuggestionPresenterTests: XCTestCase {

    func test_didLoad_deliversCorrectState() {
        let sut = makeSUT()
        var model: SearchSuggestionPresentableModel!
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

    // MARK: - Helpers

    private func makeSUT() -> SearchSuggestionPresenter {
        return SearchSuggestionPresenter()
    }
}
