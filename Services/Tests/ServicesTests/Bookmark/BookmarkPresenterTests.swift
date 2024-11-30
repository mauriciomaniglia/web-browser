import XCTest
import Services

class BookmarkPresenterTests: XCTestCase {

    func test_mapBookmarks_returnsBookmark() {
        let bookmark1 = BookmarkModel(title: "title 1", url: URL(string: "http://example1.com")!)
        let bookmark2 = BookmarkModel(title: nil, url: URL(string: "http://example2.com")!)
        let sut = BookmarkPresenter()
        var presentableModels: [BookmarkPresentableModel]!
        sut.didUpdatePresentableModels = { presentableModels = $0 }

        sut.mapBookmarks(from: [bookmark1, bookmark2])

        XCTAssertEqual(presentableModels[0].id, bookmark1.id)
        XCTAssertEqual(presentableModels[0].title, bookmark1.title)
        XCTAssertEqual(presentableModels[0].url, bookmark1.url)
        XCTAssertEqual(presentableModels[1].id, bookmark2.id)
        XCTAssertEqual(presentableModels[1].title, "http://example2.com")
        XCTAssertEqual(presentableModels[1].url, bookmark2.url)
    }
}
