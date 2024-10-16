import XCTest
import Core

class BookmarkPresenterTests: XCTestCase {

    func test_mapBookmark_returnsBookmark() {
        let page1 = WebPage(title: "title 1", url: URL(string: "http://example1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "http://example2.com")!, date: Date())
        let pages = [page1, page2]
        let sut = BookmarkPresenter()

        let presentablePages = sut.mapBookmarks(from: pages)

        XCTAssertEqual(presentablePages[0].id, page1.id)
        XCTAssertEqual(presentablePages[0].title, page1.title)
        XCTAssertEqual(presentablePages[0].url, page1.url)
        XCTAssertEqual(presentablePages[1].id, page2.id)
        XCTAssertEqual(presentablePages[1].title, "http://example2.com")
        XCTAssertEqual(presentablePages[1].url, page2.url)
    }
}
