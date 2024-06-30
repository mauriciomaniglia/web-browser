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
}
