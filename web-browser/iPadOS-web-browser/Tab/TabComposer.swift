import SwiftUI
import Services
import StorageServices

@MainActor
protocol TabUserActionDelegate: AnyObject {
    func didLoadPage(tabID: UUID)
    func didTapNewTab()
}

@MainActor
final class TabComposer: ObservableObject {
    let id: UUID
    let webKitWrapper: WebKitEngineWrapper
    let tabViewModel: TabViewModel
    let view: TabContentView
    @Published var snapshot: UIImage?

    let historyStore: HistorySwiftDataStore
    let historyComposer: HistoryComposer
    let bookmarkComposer: BookmarkComposer
    let searchSuggestionComposer: SearchSuggestionComposer
    let safelistStore: SafelistStore

    weak var userActionDelegate: TabUserActionDelegate?

    init(
        tabID: UUID? = nil,
        userActionDelegate: TabUserActionDelegate?,
        webKitWrapper: WebKitEngineWrapper,
        historyStore: HistorySwiftDataStore,
        historyComposer: HistoryComposer,
        bookmarkComposer: BookmarkComposer,
        searchSuggestionComposer: SearchSuggestionComposer,
        safelistStore: SafelistStore
    ) {
        self.id = tabID ?? UUID()
        self.userActionDelegate = userActionDelegate
        self.webKitWrapper = webKitWrapper

        self.historyStore = historyStore
        self.historyComposer = historyComposer
        self.bookmarkComposer = bookmarkComposer
        self.searchSuggestionComposer = searchSuggestionComposer
        self.safelistStore = safelistStore

        let tabManager = TabManager<WebKitEngineWrapper, SafelistStore, HistorySwiftDataStore>(
            webView: webKitWrapper,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        tabViewModel = TabViewModel(
            webBrowser: webKitWrapper,
            manager: tabManager,
            searchSuggestionComposer: searchSuggestionComposer
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

        tabViewModel.didChangeFocus = tabAdapter.didChangeFocus(isFocused:)

        view = TabContentView(
            tabViewModel: tabViewModel,
            searchSuggestionComposer: searchSuggestionComposer,
            bookmarkComposer: bookmarkComposer,
            historyComposer: historyComposer,
            webView: WebView(content: webKitWrapper.webView)
        )

        webKitWrapper.delegate = tabAdapter
    }
}
