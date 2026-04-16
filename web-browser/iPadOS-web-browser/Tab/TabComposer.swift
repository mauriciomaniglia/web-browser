import SwiftUI
import Services
import StorageServices

@MainActor
protocol TabUserActionDelegate: AnyObject {
    func didLoadPage(tabID: UUID)
    func didTapNewTab()
}

@MainActor
final class TabComposer {
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let view: TabContentView
    let id: UUID

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

        tabViewModel = TabViewModel(
            webBrowser: webKitWrapper,
            manager: tabManager,
            windowViewModel: windowViewModel
        )
        tabViewModel.didTapNewTab = userActionDelegate?.didTapNewTab

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

        view = TabContentView(
            tabViewModel: tabViewModel,
            windowViewModel: windowViewModel,
            webView: WebView(content: webKitWrapper.webView)
        )

        webKitWrapper.delegate = tabAdapter
    }
}
