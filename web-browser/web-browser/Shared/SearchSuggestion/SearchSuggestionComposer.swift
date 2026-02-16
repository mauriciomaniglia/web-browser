import Foundation
import Services

protocol SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL)
}

@MainActor
class SearchSuggestionComposer {
    let viewModel: SearchSuggestionViewModel
    let mediator: SearchSuggestionMediator
    let presenter: SearchSuggestionPresenter

    var userActionDelegate: SearchSuggestionUserActionDelegate?

    init(historyStore: HistoryStoreAPI, bookmarkStore: BookmarkStoreAPI) {
        let searchSuggestionService = SearchSuggestionService()

        self.presenter = SearchSuggestionPresenter()
        self.viewModel = SearchSuggestionViewModel()
        self.mediator = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )

        viewModel.delegate = self
    }
}

extension SearchSuggestionComposer: SearchSuggestionViewModelDelegate {
    func didStartTyping(_ text: String) {
        Task {
            let presentableModel = await mediator.didStartTyping(query: text)
            viewModel.bookmarkSuggestions = presentableModel.bookmarkSuggestions.map { .init(title: $0.title, url: $0.url)}
            viewModel.historyPageSuggestions = presentableModel.historyPageSuggestions.map { .init(title: $0.title, url: $0.url)}
            viewModel.searchSuggestions = presentableModel.searchSuggestions.map { .init(title: $0.title, url: $0.url) }
        }
    }

    func didSelectPage(_ pageURL: URL) {
        userActionDelegate?.didSelectPageFromSearchSuggestion(pageURL)
    }
}
