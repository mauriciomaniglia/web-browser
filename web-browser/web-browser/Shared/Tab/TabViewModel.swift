import Foundation
import Combine

class TabViewModel: ObservableObject {

    struct WebPage {
        let title: String
        let url: String
    }

    init(bookmarkViewModel: BookmarkViewModel)
    {
        self.bookmarkViewModel = bookmarkViewModel
    }

    let bookmarkViewModel: BookmarkViewModel

    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var showCancelButton: Bool = false
    @Published var showStopButton: Bool = false
    @Published var showReloadButton: Bool = false
    @Published var showClearButton: Bool = false
    @Published var showAddBookmark: Bool = false
    @Published var progressBarValue: Double? = nil
    @Published var title: String = ""
    @Published var urlHost: String = ""
    @Published var fullURL: String = ""
    @Published var isWebsiteProtected: Bool = true
    @Published var showSiteProtection: Bool = false
    @Published var showWebView: Bool = false
    @Published var showSearchSuggestions: Bool = false
    @Published var backList: [WebPage] = []
    @Published var showBackList: Bool = false
    @Published var forwardList: [WebPage] = []
    @Published var showForwardList: Bool = false

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didLongPressBackButton: (() -> Void)?
    var didLongPressForwardButton: (() -> Void)?
    var didSelectBackListPage: ((Int) -> Void)?
    var didSelectForwardListPage: ((Int) -> Void)?
    var didDismissBackForwardPageList: (() -> Void)?
    var didReload: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
    var didUpdateSafelist: ((String, Bool) -> Void)?
    var didChangeFocus: ((Bool) -> Void)?
    var didStartTyping: ((String, String) -> Void)?

    func didTapAddBookmark() {
        showAddBookmark = true
    }

    func dismissAddBookmark() {
        showAddBookmark = false
    }

    func saveAndDismissAddBookmark(name: String, url: String) {
        showAddBookmark = false
        bookmarkViewModel.delegate?.didTapAddBookmark(name: name, urlString: url)
    }
}
