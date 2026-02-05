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

class HistoryAdapter {
    let viewModel: HistoryViewModel
    let manager: HistoryManager

    init(viewModel: HistoryViewModel, manager: HistoryManager) {
        self.viewModel = viewModel
        self.manager = manager
    }

    func didOpenHistoryView() {
        let model = manager.didOpenHistoryView()
        mapPresentableModel(model)
    }

    func didSearchTerm(_ query: String) {
        let model = manager.didSearchTerm(query)
        mapPresentableModel(model)
    }

    func mapPresentableModel(_ model: PresentableHistory) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(id: $0.id, title: $0.title, url: $0.url)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
