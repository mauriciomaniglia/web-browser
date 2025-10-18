import SwiftUI
import Services

final class WindowComposer {
    let windowViewModel: WindowViewModel

    init(historyViewModel: HistoryViewModel,
         bookmarkViewModel: BookmarkViewModel,
         searchSuggestionViewModel: SearchSuggestionViewModel
    ) {
        self.windowViewModel = WindowViewModel(
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel
        )
    }

    func makeWindowView(
        webKitWrapper: WebKitEngineWrapper,
        historyViewModel: HistoryViewModel,
        bookmarkViewModel: BookmarkViewModel,
        searchSuggestionViewModel: SearchSuggestionViewModel,
        safelistStore: SafelistStoreAPI,
        historyStore: HistoryStoreAPI
    ) -> any View {
        let presenter = WindowPresenter(isOnSafelist: safelistStore.isRegisteredDomain(_:))
        let contentBlocking = ContentBlocking(webView: webKitWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        let mediator = WindowMediator(
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

        webKitWrapper.delegate = mediator
        presenter.delegate = self

        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return WindowIPadOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitWrapper.webView)))
        } else {
            return WindowIOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitWrapper.webView)))
        }
        #elseif os(macOS)
        return WindowMacOS(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewAppKitWrapper(webView: webKitWrapper.webView)))
        #endif
    }
}

extension WindowComposer: WindowPresenterDelegate {
    func didUpdatePresentableModel(_ model: Services.WindowPresenter.Model) {
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
