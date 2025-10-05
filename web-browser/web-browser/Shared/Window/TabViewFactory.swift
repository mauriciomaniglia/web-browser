import SwiftData
import SwiftUI
import Services

final class TabViewFactory {
    let composer: WindowComposer
    let container: ModelContainer
    let webKitWrapper: WebKitEngineWrapper
    let historyStore: HistoryStoreAPI
    let historyViewModel: HistoryViewModel
    let bookmarkViewModel: BookmarkViewModel
    let searchSuggestionViewModel: SearchSuggestionViewModel
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
        self.searchSuggestionViewModel = SearchSuggestionComposer().makeSearchSuggestionViewModel(webView: webKitWrapper, container: container)
        self.safelistStore = SafelistStore()
    }

    func makeTabView(commandMenuViewModel: CommandMenuViewModel) -> any View {
        composer.makeWindowView(
            commandMenuViewModel: commandMenuViewModel,
            webKitWrapper: webKitWrapper,
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel,
            safelistStore: safelistStore,
            historyStore: historyStore)
    }
}
