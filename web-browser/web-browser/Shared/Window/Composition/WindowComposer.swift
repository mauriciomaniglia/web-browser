import SwiftUI
import core_web_browser

final class WindowComposer {
    var viewModel = WindowViewModel()

    func composeView() -> any View {
        let webKitEngineWrapper = WebKitEngineWrapper()
        let windowPresenter = WindowPresenter()
        let safelistStore = SafelistStore()
        let windowViewAdapter = WindowViewAdapter(webView: webKitEngineWrapper, presenter: windowPresenter, safelist: safelistStore)

        viewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        viewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        viewModel.didReload = windowViewAdapter.didReload
        viewModel.didStopLoading = windowViewAdapter.didStopLoading
        viewModel.didStartSearch = windowViewAdapter.didRequestSearch
        viewModel.didUpdateSafelist = windowViewAdapter.updateSafelist(url:isEnabled:)

        webKitEngineWrapper.delegate = windowViewAdapter
        windowPresenter.didUpdatePresentableModel = didUpdatePresentableModel(_:)

        #if os(iOS)
        return IOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(macOS)
        return MacOSWindow(viewModel: viewModel, webView: AnyView(WebViewAppKitWrapper(webView: webKitEngineWrapper.webView)))
        #elseif os(visionOS)
        return VisionOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webKitEngineWrapper.webView)))
        #endif
    }

    func didUpdatePresentableModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.showStopButton = model.showStopButton
        viewModel.showReloadButton = model.showReloadButton
        viewModel.progressBarValue = model.progressBarValue
        viewModel.urlHost = model.urlHost
        viewModel.isWebsiteProtected = model.isWebsiteProtected
        viewModel.showSiteProtection = model.showSiteProtection
    }
}
