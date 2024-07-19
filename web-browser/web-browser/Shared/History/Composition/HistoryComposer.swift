import core_web_browser

class HistoryComposer {

    func makeHistoryViewModel(webView: WebEngineContract) -> HistoryViewModel {
        let viewModel = HistoryViewModel()
        let historyStore = HistoryStore()
        let presenter = HistoryPresenter(history: historyStore)
        let adapter = HistoryAdapter(viewModel: viewModel, presenter: presenter, webView: webView)

        viewModel.didSelectPageHistory = adapter.didSelectPageHistory(_:)
        viewModel.didOpenHistoryView = adapter.didOpenHistoryView
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
