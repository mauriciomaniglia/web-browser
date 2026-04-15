import Combine
import Foundation
import Services

@MainActor
class TabViewModel: ObservableObject {

    struct WebPage {
        let title: String
        let url: String
    }

    private let webBrowser: WebEngineContract
    private let manager: TabManagerAPI

    init(webBrowser: WebEngineContract, manager: TabManagerAPI) {
        self.webBrowser = webBrowser
        self.manager = manager
    }

    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var showCancelButton: Bool = false
    @Published var showStopButton: Bool = false
    @Published var showReloadButton: Bool = false
    @Published var showClearButton: Bool = false
    @Published var showAddBookmark: Bool = false
    @Published var progressBarValue: Double? = nil
    @Published var title: String = "Start Page"
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

    func didTapBackButton() {
        webBrowser.didTapBackButton()
    }

    func didTapForwardButton() {
        webBrowser.didTapForwardButton()
    }

    func didReload() {
        webBrowser.reload()
    }

    func didStopLoading() {
        webBrowser.stopLoading()
    }

    func didStartSearch(_ query: String) {
        manager.didRequestSearch(query)
    }

    func didLongPressBackButton() {
        let viewData = manager.didLoadBackList()
        mapViewData(viewData)
    }

    func didLongPressForwardButton() {
        let viewData = manager.didLoadForwardList()
        mapViewData(viewData)
    }

    func didSelectBackListPage(_ index: Int) {
        let viewData = manager.didSelectBackListPage(at: index)
        mapViewData(viewData)
    }

    func didSelectForwardListPage(_ index: Int) {
        let viewData = manager.didSelectForwardListPage(at: index)
        mapViewData(viewData)
    }

    func didDismissNavigationPageList() {
        let viewData = manager.didDismissNavigationList()
        mapViewData(viewData)
    }

    func didUpdateSafelis(isEnabled: Bool) {
        manager.updateSafelist(url: urlHost, isEnabled: isEnabled)
    }

    var didChangeFocus: ((Bool) -> Void)?
    var didStartTyping: ((String, String) -> Void)?
    var didTapNewTab: (() -> Void)?

    func didTapAddBookmark() {
        if !fullURL.isEmpty {
            showAddBookmark = true
        }
    }

    func dismissAddBookmark() {
        showAddBookmark = false
    }

    func saveAndDismissAddBookmark(name: String, url: String) {
        showAddBookmark = false
    }

    private func mapViewData(_ viewData: TabViewData) {
        isBackButtonDisabled = !viewData.canGoBack
        isForwardButtonDisabled = !viewData.canGoForward
        showCancelButton = viewData.showCancelButton
        showStopButton = viewData.showStopButton
        showReloadButton = viewData.showReloadButton
        showClearButton = viewData.showClearButton
        progressBarValue = viewData.progressBarValue
        title = viewData.title ?? ""
        urlHost = viewData.urlHost ?? ""
        fullURL = viewData.fullURL ?? ""
        isWebsiteProtected = viewData.isWebsiteProtected
        showSiteProtection = viewData.showSiteProtection
        showWebView = viewData.showWebView
        showSearchSuggestions = viewData.showSearchSuggestions
        backList = viewData.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        showBackList = viewData.backList != nil
        forwardList = viewData.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        showForwardList = viewData.forwardList != nil
    }
}
