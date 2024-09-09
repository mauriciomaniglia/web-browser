import Foundation

public class WindowPresenter {
    public var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?

    private var model: WindowPresentableModel
    private let safelist: SafelistAPI

    public init(safelist: SafelistAPI) {
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
            backList: nil,
            forwardList: nil)

        self.safelist = safelist
    }

    public func didStartNewWindow() {
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
            backList: nil,
            forwardList: nil))
    }

    public func didStartEditing() {
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
            backList: nil,
            forwardList: nil)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didEndEditing() {
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
            backList: nil,
            forwardList: nil)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            canGoBack: canGoBack,
            canGoForward: canGoForward,
            backList: model.backList,
            forwardList: model.forwardList)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didLoadPage(url: URL) {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let isOnSafelist = safelist.isRegisteredDomain(urlHost)

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
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: model.backList,
            forwardList: model.forwardList)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didLoadBackList(_ webPages: [WebPage]) {
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
            backList: webPages.map(mapWebPage).reversed(),
            forwardList: nil)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didLoadForwardList(_ webPages: [WebPage]) {
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
            backList: nil,
            forwardList: webPages.map(mapWebPage))

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didDismissBackForwardList() {
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
            backList: nil,
            forwardList: nil)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didUpdateProgressBar(_ value: Double) {
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
            backList: model.backList,
            forwardList: model.forwardList))
    }

    private func mapWebPage(_ webPage: WebPage) -> WindowPresentableModel.WebPage {
        let title = webPage.title ?? ""
        return .init(title: title.isEmpty ? webPage.url.absoluteString : title, url: webPage.url.absoluteString)
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
