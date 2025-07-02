import SwiftData
import Services

class HistoryComposer {

    func makeHistoryViewModel(webView: WebEngineContract, container: ModelContainer) -> HistoryViewModel {
        let viewModel = HistoryViewModel()
        let historyStore = HistorySwiftDataStore(container: container)
        let presenter = HistoryPresenter()
        let adapter = HistoryAdapter(viewModel: viewModel)
        let mediator = HistoryMediator(
            presenter: presenter,
            webView: webView,
            historyStore: historyStore
        )

        viewModel.didSelectPage = mediator.didSelectPage(_:)
        viewModel.didOpenHistoryView = mediator.didOpenHistoryView
        viewModel.didSearchTerm = mediator.didSearchTerm(_:)
        viewModel.didTapDeletePages = mediator.didTapDeletePages
        viewModel.didTapDeleteAllPages = mediator.didTapDeleteAllPages
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
