import Foundation
import Services

class BookmarkAdapter {
    private let webView: WebEngineContract
    private var viewModel: BookmarkViewModel

    init(webView: WebEngineContract, viewModel: BookmarkViewModel) {
        self.webView = webView
        self.viewModel = viewModel
    }

    func updateViewModel(_ models: [BookmarkPresenter.Model]) {
        let bookmarks = models.map { BookmarkViewModel.Bookmark(id: $0.id, title: $0.title, url: $0.url) }
        viewModel.bookmarkList = bookmarks
    }
}
