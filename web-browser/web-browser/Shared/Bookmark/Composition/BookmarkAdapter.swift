import Core
import Foundation

class BookmarkAdapter {
    private let webView: WebEngineContract
    private var viewModel: BookmarkViewModel

    init(webView: WebEngineContract, viewModel: BookmarkViewModel) {
        self.webView = webView
        self.viewModel = viewModel
    }

    func updateViewModel(_ models: [BookmarkPresentableModel]) {
        let bookmarks = models.map { BookmarkViewModel.Bookmark(id: $0.id, title: $0.title, url: $0.url) }
        viewModel.bookmarkList = bookmarks
    }
}
