import SwiftData
import Core

class HistoryComposer {

    func makeHistoryViewModel(webView: WebEngineContract, container: ModelContainer) -> HistoryViewModel {
        let viewModel = HistoryViewModel()
        let historyStore = HistorySwiftDataStore(container: container)
        let presenter = HistoryPresenter()
        let adapter = HistoryAdapter(viewModel: viewModel)
        let facade = HistoryFacade(presenter: presenter, webView: webView, history: historyStore)

        viewModel.didSelectPage = facade.didSelectPage(_:)
        viewModel.didOpenHistoryView = facade.didOpenHistoryView
        viewModel.didSearchTerm = facade.didSearchTerm(_:)
        viewModel.didTapDeletePages = facade.didTapDeletePages
        viewModel.didTapDeleteAllPages = facade.didTapDeleteAllPages
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
