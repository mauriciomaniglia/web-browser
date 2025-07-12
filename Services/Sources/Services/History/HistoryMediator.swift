import Foundation

public class HistoryMediator {
    private let presenter: HistoryPresenter
    private let historyStore: HistoryStoreAPI

    public init(presenter: HistoryPresenter, historyStore: HistoryStoreAPI)
    {
        self.presenter = presenter
        self.historyStore = historyStore
    }

    public func didOpenHistoryView() {
        let pages = historyStore.getPages()
        presenter.didLoadPages(pages)
    }

    public func didSearchTerm(_ term: String) {
        let pages = term.isEmpty ? historyStore.getPages() : historyStore.getPages(by: term)
        presenter.didLoadPages(pages)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        historyStore.deletePages(withIDs: pageIDs)
    }
}
