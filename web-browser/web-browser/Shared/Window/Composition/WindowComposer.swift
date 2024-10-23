import SwiftUI
import Core

final class WindowComposer {

    func makeWindowView(commandMenuViewModel: CommandMenuViewModel) -> any View {
        let webKitEngineWrapper = WebKitEngineWrapper()
        let historyViewModel = HistoryComposer().makeHistoryViewModel(webView: webKitEngineWrapper)
        let bookmarkViewModel = BookmarkComposer().makeBookmarkViewModel(webView: webKitEngineWrapper)
        let safelistStore = SafelistStore()
        let windowPresenter = WindowPresenter(safelist: safelistStore)
        var windowViewModel = WindowViewModel(historyViewModel: historyViewModel, bookmarkViewModel: bookmarkViewModel)
        let contentBlocking = ContentBlocking(webView: webKitEngineWrapper)
        let historyStore = HistorySwiftDataStore()
        let windowFacade = WindowFacade(
            webView: webKitEngineWrapper,
            presenter: windowPresenter,
            safelist: safelistStore,
            history: historyStore
        )
        let windowAdapter = WindowViewAdapter(
            webView: webKitEngineWrapper,
            viewModel: windowViewModel,
            bookmarkViewModel: bookmarkViewModel
        )

        contentBlocking.setupStrictProtection()

        windowViewModel.didTapBackButton = windowFacade.didTapBackButton
        windowViewModel.didTapForwardButton = windowFacade.didTapForwardButton
        windowViewModel.didTapCancelButton = windowFacade.didEndEditing
        windowViewModel.didReload = windowFacade.didReload
        windowViewModel.didStopLoading = windowFacade.didStopLoading
        windowViewModel.didStartSearch = windowFacade.didRequestSearch
        windowViewModel.didUpdateSafelist = windowFacade.updateSafelist(url:isEnabled:)
        windowViewModel.didBeginEditing = windowFacade.didStartEditing
        windowViewModel.didEndEditing = windowFacade.didEndEditing
        windowViewModel.didLongPressBackButton = windowFacade.didLongPressBackButton
        windowViewModel.didLongPressForwardButton = windowFacade.didLongPressForwardButton
        windowViewModel.didSelectBackListPage = windowFacade.didSelectBackListPage(at:)
        windowViewModel.didSelectForwardListPage = windowFacade.didSelectForwardListPage(at:)
        windowViewModel.didDismissBackForwardPageList = windowFacade.didDismissBackForwardList

        commandMenuViewModel.didTapAddBookmark = windowAdapter.didTapAddBookmark

        webKitEngineWrapper.delegate = windowFacade
        windowPresenter.didUpdatePresentableModel = windowAdapter.updateViewModel

        #if os(iOS)
        return IOSWindow(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(macOS)
        return MacOSWindow(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewAppKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(visionOS)
        return VisionOSWindow(
            windowViewModel: windowViewModel,
            webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #endif
    }
}
