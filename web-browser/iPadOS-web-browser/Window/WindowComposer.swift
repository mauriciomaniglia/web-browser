import SwiftData
import SwiftUI
import Services

final class WindowComposer {
    let container: ModelContainer
    let safelistStore: SafelistStore
    let historyStore: HistorySwiftDataStore
    let bookmarkStore: BookmarkSwiftDataStore

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    let tabBarManager: TabBarManager
    let windowViewModel: WindowViewModel

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

        self.windowViewModel = WindowViewModel(
            historyStore: historyStore,
            historyComposer: historyComposer,
            bookmarkComposer: bookmarkComposer,
            searchSuggestionComposer: searchSuggestionComposer,
            safelistStore: safelistStore
        )

        self.tabBarManager = TabBarManager(windowViewModel: windowViewModel)
    }

    func createNewWindow() -> WindowView {
        tabBarManager.start()

        return WindowView(tabBar: TabBarView(tabBarManager: tabBarManager))
    }
}
