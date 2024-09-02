public class HistoryFacade {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract

    public init(presenter: HistoryPresenter, webView: WebEngineContract) {
        self.presenter = presenter
        self.webView = webView
    }

    public func didOpenHistoryView() {
        presenter.didOpenHistoryView()
    }

    public func didSearchTerm(_ term: String) {
        presenter.didSearchTerm(term)
    }

    public func didSelectPage(_ url: String) {
        webView.load(SearchURLBuilder.makeURL(from: url))
    }
}
