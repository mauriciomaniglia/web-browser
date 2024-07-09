import Foundation
import core_web_browser

class WindowPresenter {
    var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    init() {
        model = WindowPresentableModel(
            urlHost: nil, 
            fullURL: nil, 
            showMenuButton: false,
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
    }

    func didStartNewWindow() {
        didUpdatePresentableModel?(.init(
            urlHost: nil,
            fullURL: nil,
            showMenuButton: true,
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

    func didStartEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didEndEditing() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didLoadPage(url: URL) {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let isOnSafelist = SafelistStore().isRegisteredDomain(urlHost)

        let newModel = WindowPresentableModel(
            urlHost: urlHost,
            fullURL: fullURL,
            showMenuButton: true,
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

    func didLoadBackList(_ webPages: [WebPage]) {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didLoadForwardList(_ webPages: [WebPage]) {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didDismissBackForwardList() {
        let newModel = WindowPresentableModel(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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

    func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        didUpdatePresentableModel?(.init(
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showMenuButton: true,
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
