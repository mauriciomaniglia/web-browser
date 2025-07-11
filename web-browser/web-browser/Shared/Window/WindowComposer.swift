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

        let webKitEngineWrapper = WebKitEngineWrapper()
        let historyViewModel = HistoryComposer().makeHistoryViewModel(webView: webKitEngineWrapper, container: container)
        let bookmarkViewModel = BookmarkComposer().makeBookmarkViewModel(webView: webKitEngineWrapper, container: container)
        let searchSuggestionViewModel = SearchSuggestionComposer().makeSearchSuggestionViewModel(webView: webKitEngineWrapper, container: container)
        let safelistStore = SafelistStore()
        let presenter = WindowPresenter(isOnSafelist: safelistStore.isRegisteredDomain(_:))
        var windowViewModel = WindowViewModel(
            historyViewModel: historyViewModel,
            bookmarkViewModel: bookmarkViewModel,
            searchSuggestionViewModel: searchSuggestionViewModel
        )
        let historyStore = HistorySwiftDataStore(container: container)
        let adapter = WindowViewAdapter(webView: webKitEngineWrapper, viewModel: windowViewModel)
        let contentBlocking = ContentBlocking(webView: webKitEngineWrapper, jsonLoader: JsonLoader.loadJsonContent(filename:))
        let mediator = WindowMediator(
            webView: webKitEngineWrapper,
            presenter: presenter,
            safelistStore: safelistStore,
            historyStore: historyStore
        )

        contentBlocking.setupStrictProtection()

        windowViewModel.didTapBackButton = webKitEngineWrapper.didTapBackButton
        windowViewModel.didTapForwardButton = webKitEngineWrapper.didTapForwardButton
        windowViewModel.didReload = webKitEngineWrapper.reload
        windowViewModel.didStopLoading = webKitEngineWrapper.stopLoading
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
        windowViewModel.didDismissBackForwardPageList = mediator.didDismissBackForwardList

        commandMenuViewModel.didTapAddBookmark = windowViewModel.didTapAddBookmark

        webKitEngineWrapper.delegate = mediator
        presenter.didUpdatePresentableModel = adapter.updateViewModel

        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return WindowIPadOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        } else {
            return WindowIOS(
                windowViewModel: windowViewModel,
                webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        }
        #elseif os(macOS)
        return WindowMacOS(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewAppKitWrapper(webView: webKitEngineWrapper.webView)))
        #endif
    }
}
