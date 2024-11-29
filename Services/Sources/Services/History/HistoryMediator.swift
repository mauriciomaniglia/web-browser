import Foundation

public class HistoryMediator {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract
    private let history: HistoryAPI

    public init(presenter: HistoryPresenter,
                webView: WebEngineContract,
                history: HistoryAPI)
    {
        self.presenter = presenter
        self.webView = webView
        self.history = history
    }

    public func didOpenHistoryView() {
        let pages = history.getPages()
        presenter.didLoadPages(pages)
    }

    public func didSearchTerm(_ term: String) {
        let pages = term.isEmpty ? history.getPages() : history.getPages(by: term)
        presenter.didLoadPages(pages)
    }

    public func didSelectPage(_ urlString: String) {
        let url = SearchURLBuilder.makeURL(from: urlString)
        webView.load(url)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        history.deletePages(withIDs: pageIDs)
    }

    public func didTapDeleteAllPages() {
        history.deleteAllPages()
    }
}
