import core_web_browser

class HistoryComposer {

    func makeHistoryViewModel(webView: WebEngineContract) -> HistoryViewModel {
        let viewModel = HistoryViewModel()
        let historyStore = HistoryStore()
        let presenter = HistoryPresenter(history: historyStore)
        let adapter = HistoryAdapter(viewModel: viewModel)
        let facade = HistoryFacade(presenter: presenter, webView: webView, history: historyStore)

        viewModel.didSelectPage = facade.didSelectPage(_:)
        viewModel.didOpenHistoryView = facade.didOpenHistoryView
        viewModel.didSearchTerm = facade.didSearchTerm(_:)
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
