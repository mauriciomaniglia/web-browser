import Foundation
import Services
import StorageServices

@MainActor
protocol HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL)
}

@MainActor
class HistoryComposer {
    let store: HistorySwiftDataStore
    let viewModel: HistoryViewModel
    let manager: HistoryManager<HistorySwiftDataStore>
    let adapter: HistoryAdapter

    var userActionDelegate: HistoryUserActionDelegate?

    init(store: HistorySwiftDataStore) {
        self.viewModel = HistoryViewModel()
        self.store = store
        self.manager = HistoryManager(store: store)
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
        store.deletePages(withIDs: pages)
    }

    func didTapDeleteAllPages() {
        store.deleteAllPages()
    }
}
