import SwiftUI
import Services

final class TabComposer {
    let webKitWrapper: WebKitEngineWrapper
    let historyViewModel: HistoryViewModel
    let bookmarkViewModel: BookmarkViewModel
    let searchSuggestionViewModel: SearchSuggestionViewModel
    let safelistStore: SafelistStoreAPI
    let historyStore: HistoryStoreAPI
    let windowViewModel: WindowViewModel
    let view: any View

    init(webKitWrapper: WebKitEngineWrapper,
         historyViewModel: HistoryViewModel,
         bookmarkViewModel: BookmarkViewModel,
         searchSuggestionViewModel: SearchSuggestionViewModel,
         safelistStore: SafelistStoreAPI,
         historyStore: HistoryStoreAPI
    ) {
        self.webKitWrapper = webKitWrapper
        self.historyViewModel = historyViewModel
        self.bookmarkViewModel = bookmarkViewModel
        self.searchSuggestionViewModel = searchSuggestionViewModel
        self.safelistStore = safelistStore
        self.historyStore = historyStore

        self.windowViewModel = WindowViewModel(
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel
        )

        let presenter = TabPresenter(isOnSafelist: safelistStore.isRegisteredDomain(_:))
        let contentBlocking = ContentBlocking(webView: webKitWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        let mediator = TabMediator(
            webView: webKitWrapper,
            presenter: presenter,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        contentBlocking.setupStrictProtection()

        windowViewModel.didTapBackButton = webKitWrapper.didTapBackButton
        windowViewModel.didTapForwardButton = webKitWrapper.didTapForwardButton
        windowViewModel.didReload = webKitWrapper.reload
        windowViewModel.didStopLoading = webKitWrapper.stopLoading
        windowViewModel.didStartSearch = mediator.didRequestSearch
        windowViewModel.didUpdateSafelist = mediator.updateSafelist(url:isEnabled:)
        windowViewModel.didChangeFocus = presenter.didChangeFocus
        windowViewModel.didStartTyping = { oldText, newText in
            searchSuggestionViewModel.delegate?.didStartTyping(newText)
            presenter.didStartTyping(oldText: oldText, newText: newText)
        }
        windowViewModel.didLongPressBackButton = mediator.didLongPressBackButton
        windowViewModel.didLongPressForwardButton = mediator.didLongPressForwardButton
        windowViewModel.didSelectBackListPage = mediator.didSelectBackListPage(at:)
        windowViewModel.didSelectForwardListPage = mediator.didSelectForwardListPage(at:)
        windowViewModel.didDismissBackForwardPageList = presenter.didDismissBackForwardList

        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.view = WindowIPadOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitWrapper.webView)))
        } else {
            self.view = WindowIOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitWrapper.webView)))
        }
        #elseif os(macOS)
        self.view = TabContentViewMacOS(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewAppKitWrapper(webView: webKitWrapper.webView)))
        #endif

        webKitWrapper.delegate = mediator
        presenter.delegate = self
    }
}

extension TabComposer: TabPresenterDelegate {
    func didUpdatePresentableModel(_ model: Services.TabPresenter.Model) {
        windowViewModel.isBackButtonDisabled = !model.canGoBack
        windowViewModel.isForwardButtonDisabled = !model.canGoForward
        windowViewModel.showCancelButton = model.showCancelButton
        windowViewModel.showStopButton = model.showStopButton
        windowViewModel.showReloadButton = model.showReloadButton
        windowViewModel.showClearButton = model.showClearButton
        windowViewModel.progressBarValue = model.progressBarValue
        windowViewModel.title = model.title ?? ""
        windowViewModel.urlHost = model.urlHost ?? ""
        windowViewModel.fullURL = model.fullURL ?? ""
        windowViewModel.isWebsiteProtected = model.isWebsiteProtected
        windowViewModel.showSiteProtection = model.showSiteProtection
        windowViewModel.showWebView = model.showWebView
        windowViewModel.showSearchSuggestions = model.showSearchSuggestions
        windowViewModel.backList = model.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        windowViewModel.showBackList = model.backList != nil
        windowViewModel.forwardList = model.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        windowViewModel.showForwardList = model.forwardList != nil
    }
}
