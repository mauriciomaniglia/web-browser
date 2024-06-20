import SwiftUI
import core_web_browser

final class WindowComposer {

    func composeView() -> any View {
        let webKitEngineWrapper = WebKitEngineWrapper()
        let windowPresenter = WindowPresenter()
        let safelistStore = SafelistStore()
        var viewModel = WindowViewModel()
        let contentBlocking = ContentBlocking(webView: webKitEngineWrapper)
        let historyStore = HistoryStore()
        let windowViewAdapter = WindowViewAdapter(
            webView: webKitEngineWrapper,
            presenter: windowPresenter,
            safelist: safelistStore,
            history: historyStore,
            viewModel: viewModel)

        contentBlocking.setupStrictProtection()

        viewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        viewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        viewModel.didTapCancelButton = windowViewAdapter.didEndEditing
        viewModel.didReload = windowViewAdapter.didReload
        viewModel.didStopLoading = windowViewAdapter.didStopLoading
        viewModel.didStartSearch = windowViewAdapter.didRequestSearch
        viewModel.didUpdateSafelist = windowViewAdapter.updateSafelist(url:isEnabled:)
        viewModel.didBeginEditing = windowViewAdapter.didStartEditing
        viewModel.didEndEditing = windowViewAdapter.didEndEditing
        viewModel.didLongPressBackButton = windowViewAdapter.didLongPressBackButton
        viewModel.didLongPressForwardButton = windowViewAdapter.didLongPressForwardButton
        viewModel.didSelectBackListPage = windowViewAdapter.didSelectBackListPage(at:)
        viewModel.didSelectForwardListPage = windowViewAdapter.didSelectForwardListPage(at:)
        viewModel.didDismissBackForwardPageList = windowViewAdapter.didDismissBackForwardList

        webKitEngineWrapper.delegate = windowViewAdapter
        windowPresenter.didUpdatePresentableModel = windowViewAdapter.updateViewModel

        #if os(iOS)
        return IOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(macOS)
        return MacOSWindow(viewModel: viewModel, webView: AnyView(WebViewAppKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(visionOS)
        return VisionOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #endif
    }
}
