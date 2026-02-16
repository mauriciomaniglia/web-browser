import Foundation
import Services

@MainActor
protocol HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL)
}

@MainActor
class HistoryComposer {
    let historyStore: HistorySwiftDataStore
    let viewModel: HistoryViewModel
    let manager: HistoryManager<HistorySwiftDataStore>
    let adapter: HistoryAdapter

    var userActionDelegate: HistoryUserActionDelegate?

    init(historyStore: HistorySwiftDataStore) {
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
