import SwiftUI
import core_web_browser

final class WindowComposer {
    var viewModel = WindowViewModel()

    func composeView() -> any View {
        let webViewProxy = WebViewProxy()
        let windowPresenter = WindowPresenter()
        let whitelistStore = WhitelistStore()
        let windowViewAdapter = WindowViewAdapter(webView: webViewProxy, presenter: windowPresenter, whitelist: whitelistStore)

        viewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        viewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        viewModel.didStartSearch = windowViewAdapter.didRequestSearch
        viewModel.didUpdateWhitelist = windowViewAdapter.updateWhitelist(url:isEnabled:)

        webViewProxy.delegate = windowViewAdapter
        windowPresenter.didUpdatePresentableModel = didUpdatePresentableModel(_:)

        #if os(iOS)
        return IOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
        #elseif os(macOS)
        return MacOSWindow(viewModel: viewModel, webView: AnyView(WebViewAppKitWrapper(webView: webViewProxy.webView)))
        #elseif os(visionOS)
        return VisionOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
        #endif
    }

    func didUpdatePresentableModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.progressBarValue = model.progressBarValue
        viewModel.url = model.pageURL
        viewModel.isWebsiteProtected = model.isWebsiteProtected
        viewModel.showSiteProtection = model.showSiteProtection
    }
}
