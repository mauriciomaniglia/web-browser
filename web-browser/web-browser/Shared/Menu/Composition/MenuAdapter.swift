import core_web_browser

class MenuAdapter {
    private var viewModel: MenuViewModel
    private let presenter: MenuPresenter
    private let webView: WebEngineContract

    init(viewModel: MenuViewModel, presenter: MenuPresenter, webView: WebEngineContract) {
        self.viewModel = viewModel
        self.presenter = presenter
        self.webView = webView
    }

    func didTapMenu() {
        presenter.didOpenMenuView()
    }

    func didTapHistory() {
        presenter.didOpenHistoryView()
    }

    func didSelectPageHistory(_ pageHistory: MenuViewModel.HistoryPage) {
        presenter.didSelectPageHistory()
        webView.load(SearchURLBuilder.makeURL(from: pageHistory.url.absoluteString))
    }

    func updateViewModel(_ model: MenuModel) {
        viewModel.showMenu = model.showMenu
        viewModel.showHistory = model.historyList != nil
        viewModel.historyList = model.historyList?.compactMap { .init(title: $0.title, url: $0.url)} ?? []
    }
}
