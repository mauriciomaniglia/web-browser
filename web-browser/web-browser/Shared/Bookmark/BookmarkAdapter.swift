import Services

class BookmarkAdapter {
    weak var viewModel: BookmarkViewModel?
    let manager: BookmarkManager<BookmarkSwiftDataStore>

    init(viewModel: BookmarkViewModel, manager: BookmarkManager<BookmarkSwiftDataStore>) {
        self.viewModel = viewModel
        self.manager = manager
    }

    func didOpenBookmarkView() {
        let presentableModels = manager.didOpenBookmarkView()
        didUpdatePresentableModels(presentableModels)
    }

    func didSearchTerm(_ query: String) {
        let presentableModels = manager.didSearchTerm(query)
        didUpdatePresentableModels(presentableModels)
    }

    func didUpdatePresentableModels(_ models: [PresentableBookmark]) {
        let bookmarks = models.map { BookmarkViewModel.Bookmark(id: $0.id, title: $0.title, url: $0.url) }
        viewModel?.bookmarkList = bookmarks
    }
}
