import SwiftUI
import Services

final class TabComposer {
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let view: any View

    init(webKitWrapper: WebKitEngineWrapper,
         bookmarkViewModel: BookmarkViewModel,
         historyViewModel: HistoryViewModel,
         searchSuggestionViewModel: SearchSuggestionViewModel,
         safelistStore: SafelistStoreAPI,
         historyStore: HistoryStoreAPI
    ) {
        self.webKitWrapper = webKitWrapper
        self.tabViewModel = TabViewModel()

        let presenter = TabPresenter(isOnSafelist: safelistStore.isRegisteredDomain(_:))
        let contentBlocking = ContentBlocking(webView: webKitWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        let mediator = TabMediator(
            webView: webKitWrapper,
            presenter: presenter,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        contentBlocking.setupStrictProtection()

        tabViewModel.didTapBackButton = webKitWrapper.didTapBackButton
        tabViewModel.didTapForwardButton = webKitWrapper.didTapForwardButton
        tabViewModel.didReload = webKitWrapper.reload
        tabViewModel.didStopLoading = webKitWrapper.stopLoading
        tabViewModel.didStartSearch = mediator.didRequestSearch
        tabViewModel.didUpdateSafelist = mediator.updateSafelist(url:isEnabled:)
        tabViewModel.didChangeFocus = presenter.didChangeFocus
        tabViewModel.didStartTyping = { oldText, newText in
            searchSuggestionViewModel.delegate?.didStartTyping(newText)
            presenter.didStartTyping(oldText: oldText, newText: newText)
        }
        tabViewModel.didLongPressBackButton = mediator.didLongPressBackButton
        tabViewModel.didLongPressForwardButton = mediator.didLongPressForwardButton
        tabViewModel.didSelectBackListPage = mediator.didSelectBackListPage(at:)
        tabViewModel.didSelectForwardListPage = mediator.didSelectForwardListPage(at:)
        tabViewModel.didDismissBackForwardPageList = presenter.didDismissBackForwardList

        #if os(iOS)
        self.view = WindowIOS(
            tabViewModel: tabViewModel,
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel,
            webView: WebView(content: webKitWrapper.webView)
        )
        #elseif os(macOS)
        self.view = TabContentViewMacOS(
            tabViewModel: tabViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel,
            webView: WebView(content: webKitWrapper.webView)
        )
        #endif

        webKitWrapper.delegate = mediator
        presenter.delegate = self
    }
}

extension TabComposer: TabPresenterDelegate {
    func didUpdatePresentableModel(_ model: Services.TabPresenter.Model) {
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
