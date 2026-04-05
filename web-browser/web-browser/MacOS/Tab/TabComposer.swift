import SwiftUI
import Services
import StorageServices

@MainActor
protocol TabUserActionDelegate: AnyObject {
    func didLoadPage(tabID: UUID)
}

@MainActor
final class TabComposer {
    let id: UUID
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let view: TabContentView

    weak var userActionDelegate: TabUserActionDelegate?

    init(
        tabID: UUID? = nil,
        userActionDelegate: TabUserActionDelegate?,
        webKitWrapper: WebKitEngineWrapper,
        windowViewModel: WindowViewModel
    ) {
        self.id = tabID ?? UUID()
        self.userActionDelegate = userActionDelegate
        self.webKitWrapper = webKitWrapper

        let tabManager = TabManager<WebKitEngineWrapper, SafelistStore, HistorySwiftDataStore>(
            webView: webKitWrapper,
            safelistStore: windowViewModel.safelistStore,
            historyStore: windowViewModel.historyStore
        )

        self.tabViewModel = TabViewModel(webBrowser: webKitWrapper, manager: tabManager)

        let tabAdapter = TabAdapter(
            tabID: id,
            tabViewModel: tabViewModel,
            tabManager: tabManager,
            userActionDelegate: userActionDelegate
        )
        let contentBlocking = ContentBlocking(
            webView: webKitWrapper,
            jsonLoader: JsonLoader.loadJsonContent(filename:)
        )
        contentBlocking.setupStrictProtection()
        
        tabViewModel.didUpdateSafelist = tabManager.updateSafelist(url:isEnabled:)
        tabViewModel.didChangeFocus = tabAdapter.didChangeFocus
        tabViewModel.didStartTyping = { [weak tabAdapter] oldText, newText in
            windowViewModel.searchSuggestionComposer.viewModel.delegate?.didStartTyping(newText)
            tabAdapter?.didStartTyping(oldText: oldText, newText: newText)
        }
        tabViewModel.didSelectBackListPage = tabAdapter.didSelectBackListPage(at:)
        tabViewModel.didSelectForwardListPage = tabAdapter.didSelectForwardListPage(at:)
        tabViewModel.didDismissNavigationPageList = tabAdapter.didDismissNavigationList

        view = TabContentView(
            tabViewModel: tabViewModel,
            searchSuggestionViewModel: windowViewModel.searchSuggestionComposer.viewModel,
            bookmarkViewModel: windowViewModel.bookmarkComposer.viewModel,
            webView: WebView(content: webKitWrapper.webView)
        )

        webKitWrapper.delegate = tabAdapter
    }
}
