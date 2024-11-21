import SwiftData
import Services

class BookmarkComposer {

    func makeBookmarkViewModel(webView: WebEngineContract, container: ModelContainer) -> BookmarkViewModel {
        let viewModel = BookmarkViewModel()
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let presenter = BookmarkPresenter()
        let adapter = BookmarkAdapter(webView: webView, viewModel: viewModel)
        let facade = BookmarkFacade(
            presenter: presenter,
            webView: webView,
            bookmark: bookmarkStore,
            urlBuilder: SearchURLBuilder.makeURL(from:)
        )

        viewModel.didTapAddBookmark = facade.didTapSavePage
        viewModel.didSelectPage = facade.didSelectPage(_:)
        viewModel.didOpenBookmarkView = facade.didOpenBookmarkView
        viewModel.didSearchTerm = facade.didSearchTerm(_:)
        viewModel.didTapDeletePages = facade.didTapDeletePages
        presenter.didUpdatePresentableModels = adapter.updateViewModel

        return viewModel
    }
}
