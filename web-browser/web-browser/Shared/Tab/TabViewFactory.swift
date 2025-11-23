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

    var tabs: [SingleTab] = []

    init() {
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        self.historyStore = HistorySwiftDataStore(container: container)
        self.bookmarkStore = BookmarkSwiftDataStore(container: container)
    }

    func createNewTab() -> SingleTab {
        let webKitWrapper = WebKitEngineWrapper()
        let historyComposer = HistoryComposer(webView: webKitWrapper, historyStore: historyStore)
        let bookmarkComposer = BookmarkComposer(webView: webKitWrapper, bookmarkStore: bookmarkStore)
        let searchSuggestionComposer = SearchSuggestionComposer(
            webView: webKitWrapper,
            historyStore: historyStore,
            bookmarkStore: bookmarkStore
        )
        let safelistStore = SafelistStore()

        let composer = TabComposer(
            webKitWrapper: webKitWrapper,
            historyViewModel: historyComposer.viewModel,
            bookmarkViewModel: bookmarkComposer.viewModel,
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

        return newTab
    }
}
