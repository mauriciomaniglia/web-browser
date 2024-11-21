import Foundation

public class HistoryFacade {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract
    private let history: HistoryAPI
    private let urlBuilder: (String) -> URL

    public init(presenter: HistoryPresenter,
                webView: WebEngineContract,
                history: HistoryAPI,
                urlBuilder: @escaping (String) -> URL)
    {
        self.presenter = presenter
        self.webView = webView
        self.history = history
        self.urlBuilder = urlBuilder
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
        let url = urlBuilder(urlString)
        webView.load(url)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        history.deletePages(withIDs: pageIDs)
    }

    public func didTapDeleteAllPages() {
        history.deleteAllPages()
    }
}
