import XCTest
import Core

class BookmarkPresenterTests: XCTestCase {

    func test_mapBookmark_returnsBookmark() {
        let page1 = WebPage(title: "title 1", url: URL(string: "http://example1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "http://example2.com")!, date: Date())
        let sut = BookmarkPresenter()
        var presentableModels: [BookmarkPresentableModel]!
        sut.didUpdatePresentableModels = { presentableModels = $0 }

        sut.mapBookmarks(from: [page1, page2])

        XCTAssertEqual(presentableModels[0].id, page1.id)
        XCTAssertEqual(presentableModels[0].title, page1.title)
        XCTAssertEqual(presentableModels[0].url, page1.url)
        XCTAssertEqual(presentableModels[1].id, page2.id)
        XCTAssertEqual(presentableModels[1].title, "http://example2.com")
        XCTAssertEqual(presentableModels[1].url, page2.url)
    }
}
