import Foundation

public class WindowPresenter {
    public var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    public init() {
        model = WindowPresentableModel(
            pageURL: nil,
            showCancelButton: false,
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
            pageURL: nil,
            showCancelButton: false,
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
            pageURL: model.pageURL,
            showCancelButton: true,
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
            pageURL: model.pageURL,
            showCancelButton: false,
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
        let pageURL = url.host ?? url.absoluteString
        let isOnWhitelist = WhitelistStore().isRegisteredDomain(pageURL)

        let newModel = WindowPresentableModel(
            pageURL: pageURL,
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: !isOnWhitelist,
            showWebView: true,
            canGoBack: canGoBack,
            canGoForward: canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        didUpdatePresentableModel?(.init(
            pageURL: model.pageURL,
            showCancelButton: false,
            showStopButton: value < 1 ? true : false,
            showReloadButton: false,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            progressBarValue: progressValue))
    }
}
