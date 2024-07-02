class MenuAdapter {
    private var viewModel: MenuViewModel
    private let presenter: MenuPresenter

    init(viewModel: MenuViewModel, presenter: MenuPresenter) {
        self.viewModel = viewModel
        self.presenter = presenter
    }

    func didTapMenu() {
        presenter.didOpenMenuView()
    }

    func updateViewModel(_ model: MenuModel) {
        viewModel.showMenu = model.showMenu
        viewModel.showHistory = model.historyList != nil
        viewModel.historyList = model.historyList?.compactMap { .init(title: $0.title, url: $0.url)} ?? []
    }
}
