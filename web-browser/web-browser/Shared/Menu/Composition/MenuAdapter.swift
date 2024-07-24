import core_web_browser

class MenuAdapter {
    private var viewModel: MenuViewModel

    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: MenuPresentableModel) {
        viewModel.showMenu = model.showMenu
        viewModel.showHistory = model.showHistory
    }
}
