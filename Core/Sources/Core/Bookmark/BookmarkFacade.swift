import Foundation

public class BookmarkFacade {
    private let presenter: BookmarkPresenter
    private let webView: WebEngineContract
    private let bookmark: BookmarkAPI

    public init(presenter: BookmarkPresenter, webView: WebEngineContract, bookmark: BookmarkAPI) {
        self.presenter = presenter
        self.webView = webView
        self.bookmark = bookmark
    }

    public func didOpenBookmarkView() {
        let webPages = bookmark.getPages()
        presenter.mapBookmarks(from: webPages)
    }

    public func didSearchTerm(_ term: String) {
        let webPages = term.isEmpty ? bookmark.getPages() : bookmark.getPages(by: term)
        presenter.mapBookmarks(from: webPages)
    }

    public func didSelectPage(_ url: String) {
        webView.load(SearchURLBuilder.makeURL(from: url))
    }

    public func didTapSavePage(title: String?, url: URL) {
        let page = WebPage(title: title, url: url, date: Date())
        bookmark.save(page: page)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        bookmark.deletePages(withIDs: pageIDs)
    }
}
