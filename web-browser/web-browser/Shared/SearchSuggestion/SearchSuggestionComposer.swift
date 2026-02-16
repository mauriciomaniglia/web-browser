import Foundation
import Services

protocol SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL)
}

@MainActor
class SearchSuggestionComposer {
    let viewModel: SearchSuggestionViewModel
    let manager: SearchSuggestionManager

    var userActionDelegate: SearchSuggestionUserActionDelegate?

    init(historyStore: HistoryStoreAPI, bookmarkStore: BookmarkStoreAPI) {
        self.viewModel = SearchSuggestionViewModel()
        let searchSuggestionService = SearchSuggestionService()
        self.manager = SearchSuggestionManager(
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
