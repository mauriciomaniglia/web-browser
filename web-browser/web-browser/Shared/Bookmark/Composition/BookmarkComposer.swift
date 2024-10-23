import Core

class BookmarkComposer {

    func makeBookmarkViewModel(webView: WebEngineContract) -> BookmarkViewModel {
        let viewModel = BookmarkViewModel()
        let bookmarkStore = BookmarkSwiftDataStore()
        let presenter = BookmarkPresenter()
        let adapter = BookmarkAdapter(viewModel: viewModel)
        let facade = BookmarkFacade(presenter: presenter, webView: webView, bookmark: bookmarkStore)

        viewModel.didSelectPage = facade.didSelectPage(_:)
        viewModel.didOpenBookmarkView = facade.didOpenBookmarkView
        viewModel.didSearchTerm = facade.didSearchTerm(_:)
        viewModel.didTapSavePage = facade.didTapSavePage
        viewModel.didTapDeletePages = facade.didTapDeletePages
        presenter.didUpdatePresentableModels = adapter.updateViewModel

        return viewModel
    }
}
