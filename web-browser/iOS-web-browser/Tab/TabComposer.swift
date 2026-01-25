import SwiftUI
import Services

final class TabComposer: ObservableObject, Identifiable {
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let id: UUID
    @Published var snapshot: UIImage?

    init(
        id: UUID? = nil,
        webKitWrapper: WebKitEngineWrapper,
        bookmarkViewModel: BookmarkViewModel,
        historyViewModel: HistoryViewModel,
        searchSuggestionViewModel: SearchSuggestionViewModel,
        safelistStore: SafelistStore,
        historyStore: HistorySwiftDataStore
    ) {
        self.id = id ?? UUID()
        self.webKitWrapper = webKitWrapper
        self.tabViewModel = TabViewModel()

        let tabManager = TabManager<WebKitEngineWrapper, SafelistStore, HistorySwiftDataStore>(
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
        tabViewModel.didStartTyping = { oldText, newText in
            searchSuggestionViewModel.delegate?.didStartTyping(newText)
            tabAdapter.didStartTyping(oldText: oldText, newText: newText)
        }
        tabViewModel.didLongPressBackButton = tabAdapter.didLoadBackList
        tabViewModel.didLongPressForwardButton = tabAdapter.didLoadForwardList
        tabViewModel.didSelectBackListPage = tabAdapter.didSelectBackListPage(at:)
        tabViewModel.didSelectForwardListPage = tabAdapter.didSelectForwardListPage(at:)
        tabViewModel.didDismissNavigationPageList = tabAdapter.didDismissNavigationList

        webKitWrapper.delegate = tabAdapter
    }
}
