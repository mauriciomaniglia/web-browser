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
    let historyViewModel: HistoryViewModel
    let bookmarkViewModel: BookmarkViewModel
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
        self.webKitWrapper = WebKitEngineWrapper()
        self.historyViewModel = HistoryComposer().makeHistoryViewModel(webView: webKitWrapper, container: container)
        self.bookmarkViewModel = BookmarkComposer().makeBookmarkViewModel(webView: webKitWrapper, container: container)
        self.searchSuggestionComposer = SearchSuggestionComposer(container: container, webView: webKitWrapper)
        self.safelistStore = SafelistStore()
    }

    func createNewTab() -> any View {
        composer.makeWindowView(
            webKitWrapper: webKitWrapper,
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            safelistStore: safelistStore,
            historyStore: historyStore)
    }
}
