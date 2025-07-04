import XCTest
@testable import Services

class BookmarkMediatorTests: XCTestCase {

    func test_didOpenBookmarkView_sendsCorrectMessage() {
        let (sut, presenter, bookmarkStore) = makeSUT()

        sut.didOpenBookmarkView()

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter, bookmarkStore) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPagesByTerm("test")])
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, presenter, bookmarkStore) = makeSUT()

        sut.didSearchTerm("")

        XCTAssertEqual(presenter.receivedMessages, [.mapBookmarks])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.getPages])
    }

    func test_didTapSavePage_sendsCorrectMessage() {
        let (sut, presenter, bookmarkStore) = makeSUT()

        sut.didTapSavePage(title: "Some title", url: "http://some-url.com")

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.save("http://some-url.com")])
    }

    func test_didTapDeletePages_sendsCorrectMessage() {
        let (sut, presenter, bookmarkStore) = makeSUT()
        let page1ID = UUID()
        let page2ID = UUID()

        sut.didTapDeletePages([page1ID, page2ID])

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(bookmarkStore.receivedMessages, [.deletePages([page1ID, page2ID])])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkMediator, presenter: BookmarkPresenterSpy, bookmarkStore: BookmarkStoreMock) {
        let bookmarkStore = BookmarkStoreMock()
        let presenter = BookmarkPresenterSpy()
        let sut = BookmarkMediator(presenter: presenter, bookmarkStore: bookmarkStore)

        return (sut, presenter, bookmarkStore)
    }
}
