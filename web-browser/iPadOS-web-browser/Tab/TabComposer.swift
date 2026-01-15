import SwiftUI
import Services

final class TabComposer {
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let view: TabContentView
    let id = UUID()

    init(webKitWrapper: WebKitEngineWrapper,
         bookmarkViewModel: BookmarkViewModel,
         historyViewModel: HistoryViewModel,
         searchSuggestionViewModel: SearchSuggestionViewModel,
         safelistStore: SafelistStoreAPI,
         historyStore: HistoryStoreAPI
    ) {
        self.webKitWrapper = webKitWrapper
        self.tabViewModel = TabViewModel()

        let tabManager = TabManager(
            webView: webKitWrapper,
            safelistStore: safelistStore,
            historyStore: historyStore
        )
        let contentBlocking = ContentBlocking(webView: webKitWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        contentBlocking.setupStrictProtection()

        tabViewModel.didTapBackButton = webKitWrapper.didTapBackButton
        tabViewModel.didTapForwardButton = webKitWrapper.didTapForwardButton
        tabViewModel.didReload = webKitWrapper.reload
        tabViewModel.didStopLoading = webKitWrapper.stopLoading
        tabViewModel.didStartSearch = tabManager.didRequestSearch
        tabViewModel.didUpdateSafelist = tabManager.updateSafelist(url:isEnabled:)
        tabViewModel.didChangeFocus = tabManager.didChangeFocus
        tabViewModel.didStartTyping = { [weak tabManager] oldText, newText in
            searchSuggestionViewModel.delegate?.didStartTyping(newText)
            tabManager?.didStartTyping(oldText: oldText, newText: newText)
        }
        tabViewModel.didLongPressBackButton = tabManager.didLoadBackList
        tabViewModel.didLongPressForwardButton = tabManager.didLoadForwardList
        tabViewModel.didSelectBackListPage = tabManager.didSelectBackListPage(at:)
        tabViewModel.didSelectForwardListPage = tabManager.didSelectForwardListPage(at:)
        tabViewModel.didDismissBackForwardPageList = tabManager.didDismissBackForwardList

        view = TabContentView(
            tabViewModel: tabViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel,
            bookmarkViewModel: bookmarkViewModel,
            historyViewModel: historyViewModel,
            webView: WebView(content: webKitWrapper.webView)
        )

        webKitWrapper.delegate = tabManager
        tabManager.delegate = self
    }
}

extension TabComposer: TabManagerDelegate {
    func didUpdatePresentableModel(_ model: TabManager.Model) {
        tabViewModel.isBackButtonDisabled = !model.canGoBack
        tabViewModel.isForwardButtonDisabled = !model.canGoForward
        tabViewModel.showCancelButton = model.showCancelButton
        tabViewModel.showStopButton = model.showStopButton
        tabViewModel.showReloadButton = model.showReloadButton
        tabViewModel.showClearButton = model.showClearButton
        tabViewModel.progressBarValue = model.progressBarValue
        tabViewModel.title = model.title ?? ""
        tabViewModel.urlHost = model.urlHost ?? ""
        tabViewModel.fullURL = model.fullURL ?? ""
        tabViewModel.isWebsiteProtected = model.isWebsiteProtected
        tabViewModel.showSiteProtection = model.showSiteProtection
        tabViewModel.showWebView = model.showWebView
        tabViewModel.showSearchSuggestions = model.showSearchSuggestions
        tabViewModel.backList = model.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        tabViewModel.showBackList = model.backList != nil
        tabViewModel.forwardList = model.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        tabViewModel.showForwardList = model.forwardList != nil
    }
}
