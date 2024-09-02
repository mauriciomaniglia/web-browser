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
        webView.load(SearchURLBuilder.makeURL(from: pageHistory.url))
    }

    func updateViewModel(_ model: HistoryPresentableModel) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(title: $0.title, url: $0.url.absoluteString)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
