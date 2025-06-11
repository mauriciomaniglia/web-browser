import SwiftData
import Services

class SearchSuggestionComposer {

    func makeSearchSuggestion(container: ModelContainer) -> SearchSuggestionMediator {
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let historyStore = HistorySwiftDataStore(container: container)
        let searchSuggestionService = SearchSuggestionService()
        let presenter = SearchSuggestionPresenter()
        let mediator = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )
        return mediator
    }
}
