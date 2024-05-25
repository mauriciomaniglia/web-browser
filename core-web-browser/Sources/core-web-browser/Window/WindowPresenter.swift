import Foundation

public class WindowPresenter {
    public var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    public init() {
        model = WindowPresentableModel(
            urlHost: nil, 
            fullURL: nil,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            canGoBack: false,
            canGoForward: false)
    }

    public func didStartNewWindow() {
        didUpdatePresentableModel?(.init(
            urlHost: nil,
            fullURL: nil,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            canGoBack: false,
            canGoForward: false))
    }

    public func didStartEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
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

    public func didEndEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
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

    public func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let isOnSafelist = SafelistStore().isRegisteredDomain(urlHost)

        let newModel = WindowPresentableModel(
            urlHost: urlHost,
            fullURL: fullURL,
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

    public func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        didUpdatePresentableModel?(.init(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
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
}
