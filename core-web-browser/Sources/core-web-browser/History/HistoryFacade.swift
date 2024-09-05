public class HistoryFacade {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract
    private let history: HistoryAPI

    public init(presenter: HistoryPresenter, webView: WebEngineContract, history: HistoryAPI) {
        self.presenter = presenter
        self.webView = webView
        self.history = history
    }

    public func didOpenHistoryView() {
        let pages: [[WebPage]] = history.getPages()
        presenter.didLoadPages(pages)
    }

    public func didSearchTerm(_ term: String) {
        presenter.didSearchTerm(term)
    }

    public func didSelectPage(_ url: String) {
        webView.load(SearchURLBuilder.makeURL(from: url))
    }
}
