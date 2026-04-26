import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct BookmarkManagerTests {

    @Test("Opening the bookmark view requests all pages and maps them to presentable models")
    func didOpenBookmarkView_sendsCorrectMessage() {
        let (sut, bookmarkStore) = Self.makeSUT()
        let bookmark = BookmarkModel(title: "Apple Store", url: URL(string: "https://www.apple.com")!)
        bookmarkStore.mockBookmarks = [bookmark]

        let presentableModels = sut.didOpenBookmarkView()

        #expect(bookmarkStore.receivedMessages == [.getPages], "Should request all pages when the view opens")
        #expect(presentableModels.count == 1, "Should produce one presentable model for the single bookmark")
        #expect(presentableModels.first?.title == "Apple Store", "Should preserve the bookmark title in the presentable model")
        #expect(presentableModels.first?.url == URL(string: "https://www.apple.com"), "Should preserve the bookmark URL in the presentable model")
    }

    @Test("Searching with a non-empty term filters pages and returns mapped results")
    func didSearchTerm_sendsCorrectMessage() {
        let (sut, bookmarkStore) = Self.makeSUT()
        let bookmark1 = BookmarkModel(title: "Apple Watch", url: URL(string: "https://www.apple.com/watch")!)
        let bookmark2 = BookmarkModel(title: "Apple Music", url: URL(string: "https://www.apple.com/music")!)
        bookmarkStore.mockBookmarks = [bookmark1, bookmark2]

        let presentableModels = sut.didSearchTerm("apple")

        #expect(bookmarkStore.receivedMessages == [.getPagesByTerm("apple")], "Should query the store with the provided search term")
        #expect(presentableModels.count == 2, "Should return two presentable models matching the mocked bookmarks")
        #expect(presentableModels.first?.title == "Apple Watch", "First result title should match the first mocked bookmark")
        #expect(presentableModels.first?.url == URL(string: "https://www.apple.com/watch"), "First result URL should match the first mocked bookmark")
        #expect(presentableModels.last?.title == "Apple Music", "Last result title should match the second mocked bookmark")
        #expect(presentableModels.last?.url == URL(string: "https://www.apple.com/music"), "Last result URL should match the second mocked bookmark")
    }

    @Test("Searching with an empty term falls back to fetching all pages")
    func didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, bookmarkStore) = Self.makeSUT()

        _ = sut.didSearchTerm("")

        #expect(bookmarkStore.receivedMessages == [.getPages], "Should request all pages when the search term is empty")
    }

    // MARK: - Helpers

    private static func makeSUT() -> (sut: BookmarkManager<BookmarkStoreMock>, bookmarkStore: BookmarkStoreMock) {
        let bookmarkStore = BookmarkStoreMock()
        let sut = BookmarkManager(bookmarkStore: bookmarkStore)
        return (sut, bookmarkStore)
    }
}
