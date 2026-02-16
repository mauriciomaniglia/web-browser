import Services
import Combine

@MainActor
class WindowViewModel: ObservableObject {
    let historyStore: HistorySwiftDataStore
    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer
    let safelistStore: SafelistStore

    init(
        historyStore: HistorySwiftDataStore,
        historyComposer: HistoryComposer,
        bookmarkComposer: BookmarkComposer,
        searchSuggestionComposer: SearchSuggestionComposer,
        safelistStore: SafelistStore
    ) {
        self.historyStore = historyStore
        self.historyComposer = historyComposer
        self.bookmarkComposer = bookmarkComposer
        self.searchSuggestionComposer = searchSuggestionComposer
        self.safelistStore = safelistStore
    }
}
