import SwiftUI
import core_web_browser

final class WindowComposer {

    func composeView() -> any View {
        let webKitEngineWrapper = WebKitEngineWrapper()
        let windowPresenter = WindowPresenter()
        let safelistStore = SafelistStore()
        var windowViewModel = WindowViewModel()
        let contentBlocking = ContentBlocking(webView: webKitEngineWrapper)
        let historyStore = HistoryStore()
        let windowViewAdapter = WindowViewAdapter(
            webView: webKitEngineWrapper,
            presenter: windowPresenter,
            safelist: safelistStore,
            history: historyStore,
            viewModel: windowViewModel)

        let menuViewModel = MenuViewModel()
        let menuPresenter = MenuPresenter(history: historyStore)
        let menuAdapter = MenuAdapter(
            viewModel: menuViewModel,
            presenter: menuPresenter,
            webView: webKitEngineWrapper)
        menuViewModel.didTapMenuButton = menuAdapter.didTapMenu
        menuViewModel.didTapHistoryOption = menuAdapter.didTapHistory
        menuViewModel.didSelectPageHistory = menuAdapter.didSelectPageHistory(_:)
        menuPresenter.didUpdatePresentableModel = menuAdapter.updateViewModel

        contentBlocking.setupStrictProtection()

        windowViewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        windowViewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        windowViewModel.didTapCancelButton = windowViewAdapter.didEndEditing
        windowViewModel.didReload = windowViewAdapter.didReload
        windowViewModel.didStopLoading = windowViewAdapter.didStopLoading
        windowViewModel.didStartSearch = windowViewAdapter.didRequestSearch
        windowViewModel.didUpdateSafelist = windowViewAdapter.updateSafelist(url:isEnabled:)
        windowViewModel.didBeginEditing = windowViewAdapter.didStartEditing
        windowViewModel.didEndEditing = windowViewAdapter.didEndEditing
        windowViewModel.didLongPressBackButton = windowViewAdapter.didLongPressBackButton
        windowViewModel.didLongPressForwardButton = windowViewAdapter.didLongPressForwardButton
        windowViewModel.didSelectBackListPage = windowViewAdapter.didSelectBackListPage(at:)
        windowViewModel.didSelectForwardListPage = windowViewAdapter.didSelectForwardListPage(at:)
        windowViewModel.didDismissBackForwardPageList = windowViewAdapter.didDismissBackForwardList

        webKitEngineWrapper.delegate = windowViewAdapter
        windowPresenter.didUpdatePresentableModel = windowViewAdapter.updateViewModel

        #if os(iOS)
        return IOSWindow(
            windowViewModel: windowViewModel,
            menuViewModel: menuViewModel,
            webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(macOS)
        return MacOSWindow(
            windowViewModel: windowViewModel,
            menuViewModel: menuViewModel,
            webView: AnyView(WebViewAppKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(visionOS)
        return VisionOSWindow(
            windowViewModel: windowViewModel,
            menuViewModel: menuViewModel,
            webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #endif
    }
}
