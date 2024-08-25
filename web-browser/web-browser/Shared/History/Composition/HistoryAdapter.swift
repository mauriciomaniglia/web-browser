import core_web_browser

class HistoryAdapter {
    private var viewModel: HistoryViewModel
    private let presenter: HistoryPresenter
    private let webView: WebEngineContract

    init(viewModel: HistoryViewModel, presenter: HistoryPresenter, webView: WebEngineContract) {
        self.viewModel = viewModel
        self.presenter = presenter
        self.webView = webView
    }

    func didOpenHistoryView() {
        presenter.didOpenHistoryView()
    }

    func didSearchTerm(_ term: String) {
        presenter.didSearchTerm(term)
    }

    func didSelectPageHistory(_ pageHistory: HistoryViewModel.Page) {        
        webView.load(SearchURLBuilder.makeURL(from: pageHistory.url.absoluteString))
    }

    func updateViewModel(_ model: HistoryPresentableModel) {
        viewModel.historyList = model.list?.compactMap { .init(title: $0.title, pages: $0.pages.map { .init(title: $0.title, url: $0.url) })} ?? []
    }
}
