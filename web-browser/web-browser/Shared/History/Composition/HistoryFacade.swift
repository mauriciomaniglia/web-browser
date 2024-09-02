import core_web_browser

class HistoryFacade {
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract

    init(presenter: HistoryPresenter, webView: WebEngineContract) {        
        self.presenter = presenter
        self.webView = webView
    }

    func didOpenHistoryView() {
        presenter.didOpenHistoryView()
    }

    func didSearchTerm(_ term: String) {
        presenter.didSearchTerm(term)
    }

    func didSelectPage(_ url: String) {
        webView.load(SearchURLBuilder.makeURL(from: url))
    }
}
