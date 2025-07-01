import SwiftData
import Services

class SearchSuggestionComposer {

    func makeSearchSuggestionViewModel(
        webView: WebEngineContract,
        container: ModelContainer) -> SearchSuggestionViewModel
    {
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let historyStore = HistorySwiftDataStore(container: container)
        let searchSuggestionService = SearchSuggestionService()
        let presenter = SearchSuggestionPresenter()
        let viewModel = SearchSuggestionViewModel()
        let adapter = SearchSuggestionAdapter(viewModel: viewModel)
        let mediator = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )

        presenter.didUpdatePresentableModel = adapter.updateViewModel(_:)
        viewModel.didStartTyping = mediator.didStartTyping
        viewModel.didSelectPage = webView.load(_:)

        return viewModel
    }
}
