import SwiftData
import Services

class HistoryComposer {
    let viewModel = HistoryViewModel()
    let presenter = HistoryPresenter()

    func makeHistoryViewModel(webView: WebEngineContract, container: ModelContainer) -> HistoryViewModel {
        let historyStore = HistorySwiftDataStore(container: container)
        let mediator = HistoryMediator(presenter: presenter, historyStore: historyStore)

        viewModel.didSelectPage = webView.load
        viewModel.didOpenHistoryView = mediator.didOpenHistoryView
        viewModel.didSearchTerm = mediator.didSearchTerm(_:)
        viewModel.didTapDeletePages = historyStore.deletePages(withIDs:)
        viewModel.didTapDeleteAllPages = historyStore.deleteAllPages

        presenter.delegate = self

        return viewModel
    }
}

extension HistoryComposer: HistoryPresenterDelegate {
    func didUpdatePresentableModel(_ model: HistoryPresenter.Model) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(id: $0.id, title: $0.title, url: $0.url)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
