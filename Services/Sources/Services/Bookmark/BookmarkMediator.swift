import Foundation

public class BookmarkMediator {
    private let presenter: BookmarkPresenter
    private let bookmarkStore: BookmarkStoreAPI

    public init(presenter: BookmarkPresenter, bookmarkStore: BookmarkStoreAPI)
    {
        self.presenter = presenter
        self.bookmarkStore = bookmarkStore
    }

    public func didOpenBookmarkView() {
        let webPages = bookmarkStore.getPages()
        presenter.mapBookmarks(from: webPages)
    }

    public func didSearchTerm(_ term: String) {
        let webPages = term.isEmpty ? bookmarkStore.getPages() : bookmarkStore.getPages(by: term)
        presenter.mapBookmarks(from: webPages)
    }
}
