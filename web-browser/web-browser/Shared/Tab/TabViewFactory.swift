import SwiftData
import SwiftUI
import Services

struct SingleTab: Identifiable {
    let id: UUID
    let webView: WebKitEngineWrapper
    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer
    let safelistStore: SafelistStore
    let tabComposer: TabComposer
}

final class TabViewFactory {
    let container: ModelContainer
    let historyStore: HistoryStoreAPI
    let bookmarkStore: BookmarkStoreAPI

    let historyComposer: HistoryComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    var tabs: [SingleTab] = []
    var selectedTab: SingleTab?

    init() {
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        self.historyStore = HistorySwiftDataStore(container: container)
        self.bookmarkStore = BookmarkSwiftDataStore(container: container)

        self.historyComposer = HistoryComposer(historyStore: historyStore)
        self.searchSuggestionComposer = SearchSuggestionComposer(historyStore: historyStore, bookmarkStore: bookmarkStore)
    }

    func createNewTab() -> SingleTab {
        let webKitWrapper = WebKitEngineWrapper()
        let bookmarkComposer = BookmarkComposer(webView: webKitWrapper, bookmarkStore: bookmarkStore)
        let safelistStore = SafelistStore()

        let composer = TabComposer(
            webKitWrapper: webKitWrapper,
            bookmarkViewModel: bookmarkComposer.viewModel,
            historyViewModel: historyComposer.viewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        let newTab = SingleTab(
            id: UUID(),
            webView: webKitWrapper,
            historyComposer: historyComposer,
            bookmarkComposer: bookmarkComposer,
            searchSuggestionComposer: searchSuggestionComposer,
            safelistStore: safelistStore,
            tabComposer: composer
        )

        tabs.append(newTab)
        selectedTab = newTab

        historyComposer.userActionDelegate = self
        searchSuggestionComposer.userActionDelegate = self

        return newTab
    }

    func didSelectTabAt(index: Int) {
        selectedTab = tabs[index]
    }
}

extension TabViewFactory: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab?.tabComposer.webKitWrapper.load(pageURL)
    }
}

extension TabViewFactory: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab?.tabComposer.webKitWrapper.load(pageURL)
    }
}
