import SwiftData
import SwiftUI
import Services

final class TabViewFactory {
    let container: ModelContainer
    let historyStore: HistoryStoreAPI
    let bookmarkStore: BookmarkStoreAPI

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    var tabs: [TabComposer] = []
    var selectedTab: TabComposer

    init() {
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        self.historyStore = HistorySwiftDataStore(container: container)
        self.bookmarkStore = BookmarkSwiftDataStore(container: container)

        self.historyComposer = HistoryComposer(historyStore: historyStore)
        self.bookmarkComposer = BookmarkComposer(bookmarkStore: bookmarkStore)
        self.searchSuggestionComposer = SearchSuggestionComposer(historyStore: historyStore, bookmarkStore: bookmarkStore)

        let webKitWrapper = WebKitEngineWrapper()
        let safelistStore = SafelistStore()
        let composer = TabComposer(
            webKitWrapper: webKitWrapper,
            bookmarkViewModel: bookmarkComposer.viewModel,
            historyViewModel: historyComposer.viewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            safelistStore: safelistStore,
            historyStore: historyStore
        )
        self.selectedTab = composer

        historyComposer.userActionDelegate = self
        bookmarkComposer.userActionDelegate = self
        searchSuggestionComposer.userActionDelegate = self
    }

    func createNewTab() -> TabComposer {
        let webKitWrapper = WebKitEngineWrapper()
        let safelistStore = SafelistStore()

        let composer = TabComposer(
            webKitWrapper: webKitWrapper,
            bookmarkViewModel: bookmarkComposer.viewModel,
            historyViewModel: historyComposer.viewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        tabs.append(composer)
        selectedTab = composer

        return composer
    }

    func didSelectTabAt(index: Int) {
        selectedTab = tabs[index]
    }
}

extension TabViewFactory: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}

extension TabViewFactory: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}

extension TabViewFactory: BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}
