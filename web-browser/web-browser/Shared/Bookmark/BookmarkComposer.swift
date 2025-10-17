import Foundation
import Services

class BookmarkComposer {
    let webView: WebEngineContract
    let bookmarkStore: BookmarkStoreAPI
    let viewModel: BookmarkViewModel
    let presenter: BookmarkPresenter
    let mediator: BookmarkMediator

    init(webView: WebEngineContract, bookmarkStore: BookmarkStoreAPI) {
        self.webView = webView
        self.bookmarkStore = bookmarkStore
        self.viewModel = BookmarkViewModel()
        self.presenter = BookmarkPresenter()
        self.mediator = BookmarkMediator(presenter: presenter, bookmarkStore: bookmarkStore)

        presenter.delegate = self
        viewModel.delegate = self
    }
}

extension BookmarkComposer: BookmarkViewModelDelegate {
    func didTapAddBookmark(name: String, urlString: String) {
        bookmarkStore.save(title: name, url: urlString)
    }
    
    func didOpenBookmarkView() {
        mediator.didOpenBookmarkView()
    }
    
    func didSearchTerm(_ query: String) {
        mediator.didSearchTerm(query)
    }
    
    func didSelectPage(_ pageURL: URL) {
        webView.load(pageURL)
    }
    
    func didTapDeletePages(_ pagesID: [UUID]) {
        bookmarkStore.deletePages(withIDs: pagesID)
    }
}

extension BookmarkComposer: BookmarkPresenterDelegate {
    func didUpdatePresentableModels(_ models: [Services.BookmarkPresenter.Model]) {
        let bookmarks = models.map { BookmarkViewModel.Bookmark(id: $0.id, title: $0.title, url: $0.url) }
        viewModel.bookmarkList = bookmarks
    }
}
