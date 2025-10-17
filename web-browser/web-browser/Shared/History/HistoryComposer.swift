import Foundation
import Services

class HistoryComposer {
    let webView: WebEngineContract
    let historyStore: HistoryStoreAPI
    let viewModel: HistoryViewModel
    let presenter: HistoryPresenter
    let mediator: HistoryMediator

    init(webView: WebEngineContract, historyStore: HistoryStoreAPI) {
        self.webView = webView
        self.viewModel = HistoryViewModel()
        self.presenter = HistoryPresenter()
        self.historyStore = historyStore
        self.mediator = HistoryMediator(presenter: presenter, historyStore: historyStore)

        viewModel.delegate = self
        presenter.delegate = self
    }
}

extension HistoryComposer: HistoryViewModelDelegate {
    func didOpenHistoryView() {
        mediator.didOpenHistoryView()
    }

    func didSearchTerm(_ query: String) {
        mediator.didSearchTerm(query)
    }

    func didSelectPage(_ pageURL: URL) {
        webView.load(pageURL)
    }

    func didTapDeletePages(_ pages: [UUID]) {
        historyStore.deletePages(withIDs: pages)
    }

    func didTapDeleteAllPages() {
        historyStore.deleteAllPages()
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
