import Foundation

public class HistoryMediator {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract
    private let historyStore: HistoryStoreAPI

    public init(presenter: HistoryPresenter,
                webView: WebEngineContract,
                historyStore: HistoryStoreAPI)
    {
        self.presenter = presenter
        self.webView = webView
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

    public func didSelectPage(_ urlString: String) {
        let url = SearchURLBuilder.makeURL(from: urlString)
        webView.load(url)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        historyStore.deletePages(withIDs: pageIDs)
    }

    public func didTapDeleteAllPages() {
        historyStore.deleteAllPages()
    }
}
