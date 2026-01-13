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

    let tabManager: TabManager

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

        self.tabManager = TabManager(
            safelistStore: safelistStore,
            historyStore: historyStore,
            bookmarkStore: bookmarkStore,
            historyComposer: historyComposer,
            bookmarkComposer: bookmarkComposer,
            searchSuggestionComposer: searchSuggestionComposer
        )
    }

    func createNewWindow() -> WindowView {
        tabManager.createNewTab()

        return WindowView(
            historyViewModel: historyComposer.viewModel,
            bookmarkViewModel: bookmarkComposer.viewModel,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            tabManager: tabManager,
        )
    }
}
