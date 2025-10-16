import SwiftData
import Services

class BookmarkComposer {
    let adapter: BookmarkAdapter
    let viewModel: BookmarkViewModel

    init(container: ModelContainer, webView: WebEngineContract) {
        self.viewModel = BookmarkViewModel()
        self.adapter = BookmarkAdapter(webView: webView, viewModel: viewModel)
    }

    func makeBookmarkViewModel(webView: WebEngineContract, container: ModelContainer) -> BookmarkViewModel {
        let bookmarkStore = BookmarkSwiftDataStore(container: container)
        let presenter = BookmarkPresenter()
        let mediator = BookmarkMediator(presenter: presenter, bookmarkStore: bookmarkStore)

        viewModel.didTapAddBookmark = bookmarkStore.save(title:url:)
        viewModel.didSelectPage = webView.load
        viewModel.didOpenBookmarkView = mediator.didOpenBookmarkView
        viewModel.didSearchTerm = mediator.didSearchTerm(_:)
        viewModel.didTapDeletePages = bookmarkStore.deletePages(withIDs:)

        presenter.delegate = self

        return viewModel
    }
}

extension BookmarkComposer: BookmarkPresenterDelegate {
    func didUpdatePresentableModels(_ models: [Services.BookmarkPresenter.Model]) {
        adapter.updateViewModel(models)
    }
}
