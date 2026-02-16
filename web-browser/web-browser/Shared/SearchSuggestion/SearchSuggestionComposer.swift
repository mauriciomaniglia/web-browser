import Foundation
import Services

@MainActor
protocol SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL)
}

@MainActor
class SearchSuggestionComposer {
    typealias SearchSuggestionManagerType = SearchSuggestionManager<SearchSuggestionService, BookmarkSwiftDataStore, HistorySwiftDataStore>

    let viewModel: SearchSuggestionViewModel
    let manager: SearchSuggestionManagerType

    var userActionDelegate: SearchSuggestionUserActionDelegate?

    init(historyStore: HistorySwiftDataStore, bookmarkStore: BookmarkSwiftDataStore) {
        self.viewModel = SearchSuggestionViewModel()
        let searchSuggestionService = SearchSuggestionService()
        self.manager = SearchSuggestionManagerType(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
        )
        viewModel.delegate = self
    }
}

extension SearchSuggestionComposer: SearchSuggestionViewModelDelegate {
    func didStartTyping(_ text: String) {
        Task {
            let presentableModel = await manager.didStartTyping(query: text)
            viewModel.bookmarkSuggestions = presentableModel.bookmarkSuggestions.map { .init(title: $0.title, url: $0.url)}
            viewModel.historyPageSuggestions = presentableModel.historyPageSuggestions.map { .init(title: $0.title, url: $0.url)}
            viewModel.searchSuggestions = presentableModel.searchSuggestions.map { .init(title: $0.title, url: $0.url) }
        }
    }

    func didSelectPage(_ pageURL: URL) {
        userActionDelegate?.didSelectPageFromSearchSuggestion(pageURL)
    }
}
