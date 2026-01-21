import SwiftData
import SwiftUI
import Services

final class TabBarManager: ObservableObject {
    @Published var tabs: [TabComposer] = []
    @Published var selectedTab: TabComposer?

    let safelistStore: SafelistStore
    let historyStore: HistorySwiftDataStore
    let bookmarkStore: BookmarkStoreAPI

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    init(safelistStore: SafelistStore,
         historyStore: HistorySwiftDataStore,
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

    func createNewTab() {
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
    }

    func didSelectTab(at index: Int) {
        selectedTab = tabs[index]
    }

    func closeTab(at index: Int) {
        if index == 0 && tabs.count == 1 {
            tabs.remove(at: 0)
            selectedTab = nil
            createNewTab()
            return
        }

        selectedTab = (index > 0) ? tabs[index - 1] : tabs[index + 1]
        tabs.remove(at: index)
    }

    func closeAllTabs() {
        tabs.removeAll()
        selectedTab = nil
        createNewTab()
    }
}

extension TabBarManager: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabBarManager: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabBarManager: BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}
