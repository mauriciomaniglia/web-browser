import Foundation
import Services

@MainActor
protocol BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL)
}

@MainActor
class BookmarkComposer {
    let store: BookmarkStoreAPI
    let viewModel: BookmarkViewModel
    let manager: BookmarkManager<BookmarkSwiftDataStore>

    var userActionDelegate: BookmarkUserActionDelegate?

    init(bookmarkStore: BookmarkSwiftDataStore) {
        self.store = bookmarkStore
        self.manager = BookmarkManager(bookmarkStore: bookmarkStore)
        self.viewModel = BookmarkViewModel(store: bookmarkStore, manager: manager)
    }
}
