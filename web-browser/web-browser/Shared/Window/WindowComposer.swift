import SwiftData
import SwiftUI
import Services

final class WindowComposer {
    let container: ModelContainer
    let safelistStore: SafelistStoreAPI
    let historyStore: HistoryStoreAPI
    let bookmarkStore: BookmarkStoreAPI

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    var tabs: [TabComposer] = []
    var selectedTab: TabComposer
    var selectedTabIndex: Int = 0

    init() {
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        self.safelistStore = SafelistStore()

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
        selectedTabIndex = tabs.count + 1

        return composer
    }

    func didSelectTab(at index: Int) {
        selectedTab = tabs[index]
        selectedTabIndex = index
    }
}

extension WindowComposer: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}

extension WindowComposer: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}

extension WindowComposer: BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL) {
        selectedTab.webKitWrapper.load(pageURL)
    }
}
