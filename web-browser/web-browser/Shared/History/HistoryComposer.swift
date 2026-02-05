import Foundation
import Services

protocol HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL)
}

class HistoryComposer {
    let historyStore: HistoryStoreAPI
    let viewModel: HistoryViewModel
    let manager: HistoryManager
    let adapter: HistoryAdapter

    var userActionDelegate: HistoryUserActionDelegate?

    init(historyStore: HistoryStoreAPI) {
        self.viewModel = HistoryViewModel()
        self.historyStore = historyStore
        self.manager = HistoryManager(historyStore: historyStore)
        self.adapter = HistoryAdapter(viewModel: viewModel, manager: manager)

        viewModel.delegate = self
    }
}

extension HistoryComposer: HistoryViewModelDelegate {
    func didOpenHistoryView() {
        adapter.didOpenHistoryView()
    }

    func didSearchTerm(_ query: String) {
        adapter.didSearchTerm(query)
    }

    func didSelectPage(_ pageURL: URL) {
        userActionDelegate?.didSelectPage(pageURL)
    }

    func didTapDeletePages(_ pages: [UUID]) {
        historyStore.deletePages(withIDs: pages)
    }

    func didTapDeleteAllPages() {
        historyStore.deleteAllPages()
    }
}
