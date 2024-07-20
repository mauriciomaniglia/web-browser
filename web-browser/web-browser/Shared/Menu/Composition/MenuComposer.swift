import core_web_browser

class MenuComposer {

    func makeViewModel(webView: WebEngineContract) -> MenuViewModel {
        let viewModel = MenuViewModel(webView: webView)
        let presenter = MenuPresenter()
        let adapter = MenuAdapter(viewModel: viewModel, presenter: presenter, webView: webView)
        viewModel.didTapMenuButton = adapter.didTapMenu
        viewModel.didTapHistoryOption = adapter.didTapHistory
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        return viewModel
    }
}
