import SwiftUI
import core_web_browser

class ViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var progressBarValue: Double? = nil

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
}

final class WindowComposer {
    var viewModel = ViewModel()

    func composeView() -> any View {
        let webViewProxy = WebViewProxy()
        let windowPresenter = WindowPresenter()
        let windowViewAdapter = WindowViewAdapter(webView: webViewProxy, presenter: windowPresenter)

        viewModel.didTapBackButton = windowViewAdapter.didTapBackButton
        viewModel.didTapForwardButton = windowViewAdapter.didTapForwardButton
        viewModel.didStartSearch = windowViewAdapter.didRequestSearch

        webViewProxy.delegate = windowViewAdapter
        windowPresenter.didUpdatePresentableModel = didUpdatePresentableModel(_:)

        #if os(iOS)
        return IOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
        #elseif os(macOS)
        return MacOSWindow(viewModel: viewModel, webView: AnyView(WebViewAppKitWrapper(webView: webViewProxy.webView)))
        #elseif os(visionOS)
        var visionLayout = VisionOSWindow(viewModel: viewModel, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
        #endif

    }

    func didUpdatePresentableModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.progressBarValue = model.progressBarValue
    }
}
