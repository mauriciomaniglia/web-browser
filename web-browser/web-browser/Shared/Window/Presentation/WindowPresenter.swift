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
            canGoForward: false, 
            backForwardList: nil)
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
            canGoForward: false,
            backForwardList: nil))
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
            canGoForward: model.canGoForward,
            backForwardList: nil)

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
            canGoForward: model.canGoForward,
            backForwardList: nil)

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
            canGoForward: canGoForward,
            backForwardList: model.backForwardList)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    func didLoadBackForwardList(_ webPages: [WebPage]) {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: model.showCancelButton,
            showClearButton: model.showClearButton,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backForwardList: webPages.map { .init(title: $0.title, url: $0.url) })

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
            progressBarValue: progressValue,
            backForwardList: model.backForwardList))
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
