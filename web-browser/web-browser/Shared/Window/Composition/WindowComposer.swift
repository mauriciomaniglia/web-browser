import SwiftUI
import core_web_browser

final class WindowComposer {

    func composeView() -> any View {
        let webKitEngineWrapper = WebKitEngineWrapper()
        let windowPresenter = WindowPresenter()
        let safelistStore = SafelistStore()
        var viewModel = WindowViewModel()
        let windowViewAdapter = WindowViewAdapter(webView: webKitEngineWrapper, presenter: windowPresenter, safelist: safelistStore, viewModel: viewModel)

        viewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        viewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        viewModel.didReload = windowViewAdapter.didReload
        viewModel.didStopLoading = windowViewAdapter.didStopLoading
        viewModel.didStartSearch = windowViewAdapter.didRequestSearch
        viewModel.didUpdateSafelist = windowViewAdapter.updateSafelist(url:isEnabled:)
        viewModel.didBeginEditing = windowViewAdapter.didStartEditing
        viewModel.didEndEditing = windowViewAdapter.didEndEditing

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
