import SwiftUI
import Services
import StorageServices

@MainActor
protocol TabUserActionDelegate: AnyObject {
    func didLoadPage(tabID: UUID)
}

@MainActor
final class TabComposer: ObservableObject, Identifiable {
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let id: UUID
    @Published var snapshot: UIImage?

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

        webKitWrapper.delegate = tabAdapter
    }
}
