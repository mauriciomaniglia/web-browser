import core_web_browser

class MenuComposer {

    func makeViewModel(webView: WebEngineContract) -> MenuViewModel {
        let viewModel = MenuViewModel(webView: webView)
        let presenter = MenuPresenter()
        let adapter = MenuAdapter(viewModel: viewModel)
        viewModel.didTapMenuButton = presenter.didOpenMenuView
        viewModel.didTapHistoryOption = presenter.didOpenHistoryView
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
