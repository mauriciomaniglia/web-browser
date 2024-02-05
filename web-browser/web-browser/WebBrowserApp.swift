import SwiftUI
import core_web_browser

@main
struct WebBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            AnyView(composeView())
        }
    }
}

var viewModel = ViewModel()

func composeView() -> any View {
    let webViewProxy = WebViewProxy()
    let windowPresenter = WindowPresenter()
    var windowViewAdapter = WindowViewAdapter(webView: webViewProxy, presenter: windowPresenter)

    webViewProxy.delegate = windowViewAdapter
    windowPresenter.didUpdatePresentableModel = didUpdatePresentableModel(_:)

    #if os(iOS)
    var iosLayout = IOSWindow(viewModel: viewModel, onEnterPressed: { windowViewAdapter.didRequestSearch($0) }, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
    iosLayout.onBackButtonPressed = {
        windowViewAdapter.didTapBackButton()
    }
    iosLayout.onForwardButtonPressed = {
        windowViewAdapter.didTapForwardButton()
    }
    return iosLayout
    #elseif os(macOS)
    var macLayout = MacOSWindow(viewModel: viewModel, onEnterPressed: { windowViewAdapter.didRequestSearch($0) }, webView: AnyView(WebViewAppKitWrapper(webView: webViewProxy.webView)))
    macLayout.onBackButtonPressed = {
        windowViewAdapter.didTapBackButton()
    }
    macLayout.onForwardButtonPressed = {
        windowViewAdapter.didTapForwardButton()
    }
    return macLayout
    #elseif os(visionOS)
    var visionLayout = VisionOSWindow(viewModel: viewModel, onEnterPressed: { windowViewAdapter.didRequestSearch($0) }, webView: AnyView(WebViewUIKitWrapper(webView: webViewProxy.webView)))
    visionLayout.onBackButtonPressed = {
        windowViewAdapter.didTapBackButton()
    }
    visionLayout.onForwardButtonPressed = {
        windowViewAdapter.didTapForwardButton()
    }
    return visionLayout
    #endif

}

func didUpdatePresentableModel(_ model: WindowPresentableModel) {
    viewModel.isBackButtonDisabled = !model.canGoBack
    viewModel.isForwardButtonDisabled = !model.canGoForward
    viewModel.progressBarValue = model.progressBar
}

class ViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var progressBarValue: Double? = nil
}
