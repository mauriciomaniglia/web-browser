import Core

class BookmarkAdapter {
    private var viewModel: BookmarkViewModel

    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ models: [BookmarkPresentableModel]) {
        let bookmarks = models.map { BookmarkViewModel.Bookmark(id: $0.id, title: $0.title, url: $0.url) }
        viewModel.bookmarkList = bookmarks
    }
}
