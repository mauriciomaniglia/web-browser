import SwiftData
import Services

class BookmarkComposer {

    func makeBookmarkViewModel(webView: WebEngineContract, container: ModelContainer) -> BookmarkViewModel {
        let viewModel = BookmarkViewModel()
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let presenter = BookmarkPresenter()
        let adapter = BookmarkAdapter(webView: webView, viewModel: viewModel)
        let mediator = BookmarkMediator(presenter: presenter, bookmarkStore: bookmarkStore)

        viewModel.didTapAddBookmark = mediator.didTapSavePage
        viewModel.didSelectPage = webView.load
        viewModel.didOpenBookmarkView = mediator.didOpenBookmarkView
        viewModel.didSearchTerm = mediator.didSearchTerm(_:)
        viewModel.didTapDeletePages = bookmarkStore.deletePages(withIDs:)
        presenter.didUpdatePresentableModels = adapter.updateViewModel

        return viewModel
    }
}
