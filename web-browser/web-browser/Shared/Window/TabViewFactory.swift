import SwiftData
import SwiftUI
import Services

protocol TabFactory {
    func createNewTab() -> any View
}

final class TabViewFactory: TabFactory {
    let composer: WindowComposer
    let container: ModelContainer
    let webKitWrapper: WebKitEngineWrapper
    let historyStore: HistoryStoreAPI
    let bookmarkStore: BookmarkStoreAPI
    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer
    let safelistStore: SafelistStoreAPI

    init() {
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        self.composer = WindowComposer()
        self.historyStore = HistorySwiftDataStore(container: container)
        self.bookmarkStore = BookmarkSwiftDataStore(container: container)
        self.webKitWrapper = WebKitEngineWrapper()
        self.historyComposer = HistoryComposer(webView: webKitWrapper, historyStore: historyStore)
        self.bookmarkComposer = BookmarkComposer(webView: webKitWrapper, bookmarkStore: bookmarkStore)
        self.searchSuggestionComposer = SearchSuggestionComposer(
            webView: webKitWrapper,
            historyStore: historyStore,
            bookmarkStore: bookmarkStore
        )
        self.safelistStore = SafelistStore()
    }

    func createNewTab() -> any View {
        composer.makeWindowView(
            webKitWrapper: webKitWrapper,
            historyViewModel: historyComposer.viewModel,
            bookmarkViewModel: bookmarkComposer.viewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            safelistStore: safelistStore,
            historyStore: historyStore)
    }
}
