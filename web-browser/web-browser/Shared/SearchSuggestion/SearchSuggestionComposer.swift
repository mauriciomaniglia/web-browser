import Foundation
import SwiftData
import Services

class SearchSuggestionComposer {
    let viewModel: SearchSuggestionViewModel
    let mediator: SearchSuggestionMediator
    let presenter: SearchSuggestionPresenter
    let webView: WebEngineContract

    init(container: ModelContainer, webView: WebEngineContract) {
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let historyStore = HistorySwiftDataStore(container: container)
        let searchSuggestionService = SearchSuggestionService()

        self.webView = webView
        self.presenter = SearchSuggestionPresenter()
        self.viewModel = SearchSuggestionViewModel()
        self.mediator = SearchSuggestionMediator(
            searchSuggestionService: searchSuggestionService,
            bookmarkStore: bookmarkStore,
            historyStore: historyStore,
            presenter: presenter
        )

        presenter.delegate = self
        viewModel.delegate = self
    }
}

extension SearchSuggestionComposer: SearchSuggestionViewModelDelegate {
    func didStartTyping(_ text: String) {
        mediator.didStartTyping(query: text)
    }

    func didSelectPage(_ pageURL: URL) {
        webView.load(pageURL)
    }
}

extension SearchSuggestionComposer: SearchSuggestionPresenterDelegate {
    func didUpdatePresentableModel(_ model: Services.SearchSuggestionPresenter.Model) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.bookmarkSuggestions = model.bookmarkSuggestions.map { .init(title: $0.title, url: $0.url)}
            self?.viewModel.historyPageSuggestions = model.historyPageSuggestions.map { .init(title: $0.title, url: $0.url)}
            self?.viewModel.searchSuggestions = model.searchSuggestions.map { .init(title: $0.title, url: $0.url) }
        }
    }
}
