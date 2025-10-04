import SwiftData
import SwiftUI
@testable import Services

final class WindowComposer {

    func makeWindowView(commandMenuViewModel: CommandMenuViewModel) -> any View {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: HistorySwiftDataStore.HistoryPage.self, BookmarkSwiftDataStore.Bookmark.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        let webKitWrapper = WebKitEngineWrapper()
        let historyViewModel = HistoryComposer().makeHistoryViewModel(webView: webKitWrapper, container: container)
        let bookmarkViewModel = BookmarkComposer().makeBookmarkViewModel(webView: webKitWrapper, container: container)
        let searchSuggestionViewModel = SearchSuggestionComposer().makeSearchSuggestionViewModel(webView: webKitWrapper, container: container)
        let safelistStore = SafelistStore()
        let presenter = WindowPresenter(isOnSafelist: safelistStore.isRegisteredDomain(_:))
        var windowViewModel = WindowViewModel(
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel
        )
        let historyStore = HistorySwiftDataStore(container: container)
        let adapter = WindowViewAdapter(webView: webKitWrapper, viewModel: windowViewModel)
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
            searchSuggestionViewModel.didStartTyping?(newText)
            presenter.didStartTyping(oldText: oldText, newText: newText)
        }
        windowViewModel.didLongPressBackButton = mediator.didLongPressBackButton
        windowViewModel.didLongPressForwardButton = mediator.didLongPressForwardButton
        windowViewModel.didSelectBackListPage = mediator.didSelectBackListPage(at:)
        windowViewModel.didSelectForwardListPage = mediator.didSelectForwardListPage(at:)
        windowViewModel.didDismissBackForwardPageList = presenter.didDismissBackForwardList

        commandMenuViewModel.didTapAddBookmark = windowViewModel.didTapAddBookmark

        webKitWrapper.delegate = mediator
        presenter.didUpdatePresentableModel = adapter.updateViewModel

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
