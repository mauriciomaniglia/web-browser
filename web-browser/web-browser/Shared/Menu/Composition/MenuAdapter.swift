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

    func updateViewModel(_ model: MenuModel) {
        viewModel.showMenu = model.showMenu
        viewModel.showHistory = model.showHistory
    }
}
