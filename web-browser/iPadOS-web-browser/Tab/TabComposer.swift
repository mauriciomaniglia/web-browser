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
        let tabAdapter = TabAdapter(tabViewModel: tabViewModel, tabManager: tabManager)
        let contentBlocking = ContentBlocking(webView: webKitWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        contentBlocking.setupStrictProtection()

        tabViewModel.didTapBackButton = webKitWrapper.didTapBackButton
        tabViewModel.didTapForwardButton = webKitWrapper.didTapForwardButton
        tabViewModel.didReload = webKitWrapper.reload
        tabViewModel.didStopLoading = webKitWrapper.stopLoading
        tabViewModel.didStartSearch = tabManager.didRequestSearch
        tabViewModel.didUpdateSafelist = tabManager.updateSafelist(url:isEnabled:)
        tabViewModel.didChangeFocus = tabAdapter.didChangeFocus
        tabViewModel.didStartTyping = { [weak tabAdapter] oldText, newText in
            searchSuggestionViewModel.delegate?.didStartTyping(newText)
            tabAdapter?.didStartTyping(oldText: oldText, newText: newText)
        }
        tabViewModel.didLongPressBackButton = tabAdapter.didLoadBackList
        tabViewModel.didLongPressForwardButton = tabAdapter.didLoadForwardList
        tabViewModel.didSelectBackListPage = tabAdapter.didSelectBackListPage(at:)
        tabViewModel.didSelectForwardListPage = tabAdapter.didSelectForwardListPage(at:)
        tabViewModel.didDismissNavigationPageList = tabAdapter.didDismissNavigationList

        view = TabContentView(
            tabViewModel: tabViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel,
            bookmarkViewModel: bookmarkViewModel,
            historyViewModel: historyViewModel,
            webView: WebView(content: webKitWrapper.webView)
        )

        webKitWrapper.delegate = tabAdapter
    }
}
