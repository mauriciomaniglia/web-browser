import SwiftData
import SwiftUI
import Services

@MainActor
final class WindowComposer {
    let container: ModelContainer
    let safelistStore: SafelistStore
    let historyStore: HistorySwiftDataStore
    let bookmarkStore: BookmarkSwiftDataStore

    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer

    let tabSessionStore: TabSessionStore
    let tabBarManager: TabBarManager<TabSessionStore>
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

        self.tabSessionStore = TabSessionStore()
        self.tabBarManager = TabBarManager(windowViewModel: windowViewModel, tabBarStore: tabSessionStore)
    }

    func createNewWindow() -> WindowView {
        tabBarManager.start()

        let menu = MenuView(
            bookmarkViewModel: bookmarkComposer.viewModel,
            historyViewModel: historyComposer.viewModel
        )
        let tabBar = TabBarView(
            tabBarManager: tabBarManager,
            layout: .init(
                padding: 16,
                innerPadding: 12,
                cornerRadius: 20,
                color: .green,
                selectedColor: .blue,
                unselectedColor: .clear
            )
        )

        return WindowView(
            tabBarManager: tabBarManager,
            searchSuggestionViewModel: searchSuggestionComposer.viewModel,
            menu: menu,
            tabBar: tabBar)
    }
}
