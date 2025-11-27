import Foundation
import Services

protocol BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL)
}

class BookmarkComposer {
    let bookmarkStore: BookmarkStoreAPI
    let viewModel: BookmarkViewModel
    let presenter: BookmarkPresenter
    let mediator: BookmarkMediator

    var userActionDelegate: BookmarkUserActionDelegate?

    init(bookmarkStore: BookmarkStoreAPI) {
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
        userActionDelegate?.didSelectPageFromBookmark(pageURL)
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
