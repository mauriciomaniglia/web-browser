import Foundation

public class BookmarkFacade {
    private let presenter: BookmarkPresenter
    private let webView: WebEngineContract
    private let bookmark: BookmarkAPI
    private let urlBuilder: (String) -> URL

    public init(presenter: BookmarkPresenter,
                webView: WebEngineContract,
                bookmark: BookmarkAPI,
                urlBuilder: @escaping (String) -> URL)
    {
        self.presenter = presenter
        self.webView = webView
        self.bookmark = bookmark
        self.urlBuilder = urlBuilder
    }

    public func didOpenBookmarkView() {
        let webPages = bookmark.getPages()
        presenter.mapBookmarks(from: webPages)
    }

    public func didSearchTerm(_ term: String) {
        let webPages = term.isEmpty ? bookmark.getPages() : bookmark.getPages(by: term)
        presenter.mapBookmarks(from: webPages)
    }

    public func didSelectPage(_ urlString: String) {
        let url = urlBuilder(urlString)
        webView.load(url)
    }

    public func didTapSavePage(title: String, url: String) {
        let page = BookmarkModel(title: title, url: URL(string: url)!)
        bookmark.save(page)
    }

    public func didTapDeletePages(_ pageIDs: [UUID]) {
        bookmark.deletePages(withIDs: pageIDs)
    }
}
