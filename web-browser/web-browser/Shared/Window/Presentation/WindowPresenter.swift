import Foundation
import core_web_browser

class WindowPresenter {
    var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    init() {
        model = WindowPresentableModel(
            urlHost: nil, 
            fullURL: nil, 
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            canGoBack: false,
            canGoForward: false)
    }

    func didStartNewWindow() {
        didUpdatePresentableModel?(.init(
            urlHost: nil,
            fullURL: nil,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            canGoBack: false,
            canGoForward: false))
    }

    func didStartEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: showCancelButton(),
            showClearButton: true,
            showStopButton: false,
            showReloadButton: false,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: model.showWebView,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    func didEndEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton, 
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: model.showWebView,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let isOnSafelist = SafelistStore().isRegisteredDomain(urlHost)

        let newModel = WindowPresentableModel(
            urlHost: urlHost,
            fullURL: fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: !isOnSafelist,
            showWebView: true,
            canGoBack: canGoBack,
            canGoForward: canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        didUpdatePresentableModel?(.init(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: value < 1 ? true : false,
            showReloadButton: value >= 1 ? true : false,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            progressBarValue: progressValue))
    }

    private func showCancelButton() -> Bool {
        #if os(iOS)
        true
        #elseif os(macOS)
        false
        #elseif os(visionOS)
        false
        #endif
    }
}
