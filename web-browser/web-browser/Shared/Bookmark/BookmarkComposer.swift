import SwiftData
import Services

class BookmarkComposer {

    func makeBookmarkViewModel(webView: WebEngineContract, container: ModelContainer) -> BookmarkViewModel {
        let viewModel = BookmarkViewModel()
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let presenter = BookmarkPresenter()
        let adapter = BookmarkAdapter(webView: webView, viewModel: viewModel)
        let mediator = BookmarkMediator(
            presenter: presenter,
            webView: webView,
            bookmarkStore: bookmarkStore
        )

        viewModel.didTapAddBookmark = mediator.didTapSavePage
        viewModel.didSelectPage = mediator.didSelectPage(_:)
        viewModel.didOpenBookmarkView = mediator.didOpenBookmarkView
        viewModel.didSearchTerm = mediator.didSearchTerm(_:)
        viewModel.didTapDeletePages = mediator.didTapDeletePages
        presenter.didUpdatePresentableModels = adapter.updateViewModel

        return viewModel
    }
}
