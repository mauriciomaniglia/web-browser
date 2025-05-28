import Foundation

public class BookmarkMediator {
    private let presenter: BookmarkPresenter
    private let webView: WebEngineContract
    private let bookmarkStore: BookmarkStoreAPI

    public init(presenter: BookmarkPresenter,
                webView: WebEngineContract,
                bookmarkStore: BookmarkStoreAPI)
    {
        self.presenter = presenter
        self.webView = webView
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

    public func didSelectPage(_ urlString: String) {
        let url = SearchAPI.makeURL(from: urlString)
        webView.load(url)
    }

    public func didTapSavePage(title: String, url: String) {
        let page = BookmarkModel(title: title, url: URL(string: url)!)
        bookmarkStore.save(page)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        bookmarkStore.deletePages(withIDs: pageIDs)
    }
}
