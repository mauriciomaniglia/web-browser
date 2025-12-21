import SwiftData
import SwiftUI
import Services

final class TabManager {
    let safelistStore: SafelistStoreAPI
    let historyStore: HistoryStoreAPI
    let bookmarkStore: BookmarkStoreAPI

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    var tabs: [TabComposer] = []
    var selectedTab: TabComposer?
    var selectedTabIndex: Int = 0

    init(safelistStore: SafelistStoreAPI,
         historyStore: HistoryStoreAPI,
         bookmarkStore: BookmarkStoreAPI,
         historyComposer: HistoryComposer,
         bookmarkComposer: BookmarkComposer,
         searchSuggestionComposer: SearchSuggestionComposer
    ) {
        self.safelistStore = safelistStore
        self.historyStore = historyStore
        self.bookmarkStore = bookmarkStore
        self.historyComposer = historyComposer
        self.bookmarkComposer = bookmarkComposer
        self.searchSuggestionComposer = searchSuggestionComposer

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

    func closeTab(at index: Int) {
        tabs.remove(at: index)
    }
}

extension TabManager: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabManager: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabManager: BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}
