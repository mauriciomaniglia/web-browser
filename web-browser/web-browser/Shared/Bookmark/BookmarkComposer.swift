import Foundation
import Services

protocol BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL)
}

class BookmarkComposer {
    let bookmarkStore: BookmarkStoreAPI
    let viewModel: BookmarkViewModel
    let manager: BookmarkManager
    let adapter: BookmarkAdapter

    var userActionDelegate: BookmarkUserActionDelegate?

    init(bookmarkStore: BookmarkStoreAPI) {
        self.bookmarkStore = bookmarkStore
        self.viewModel = BookmarkViewModel()
        self.manager = BookmarkManager(bookmarkStore: bookmarkStore)
        self.adapter = BookmarkAdapter(viewModel: viewModel, manager: manager)

        viewModel.delegate = self
    }
}

extension BookmarkComposer: BookmarkViewModelDelegate {
    func didTapAddBookmark(name: String, urlString: String) {
        bookmarkStore.save(title: name, url: urlString)
    }
    
    func didOpenBookmarkView() {
        adapter.didOpenBookmarkView()
    }
    
    func didSearchTerm(_ query: String) {
        adapter.didSearchTerm(query)
    }
    
    func didSelectPage(_ pageURL: URL) {
        userActionDelegate?.didSelectPageFromBookmark(pageURL)
    }
    
    func didTapDeletePages(_ pagesID: [UUID]) {
        bookmarkStore.deletePages(withIDs: pagesID)
    }
}
