import Foundation

public protocol TabManagerDelegate: AnyObject {
    func didUpdatePresentableModel(_ model: TabManager.Model)
}

public class TabManager {

    public struct Model {

        public struct Page {
            public let title: String
            public let url: String
        }

        public let title: String?
        public let urlHost: String?
        public let fullURL: String?
        public let showCancelButton: Bool
        public let showClearButton: Bool
        public let showStopButton: Bool
        public let showReloadButton: Bool
        public let showSiteProtection: Bool
        public let isWebsiteProtected: Bool
        public let showWebView: Bool
        public let showSearchSuggestions: Bool
        public let canGoBack: Bool
        public let canGoForward: Bool
        public var progressBarValue: Double?
        public let backList: [Page]?
        public let forwardList: [Page]?
    }

    public weak var delegate: TabManagerDelegate?

    private let webView: WebEngineContract
    private let safelistStore: SafelistStoreAPI
    private let historyStore: HistoryStoreAPI
    private var model: Model

    public init(webView: WebEngineContract, safelistStore: SafelistStoreAPI, historyStore: HistoryStoreAPI) {
        self.webView = webView
        self.safelistStore = safelistStore
        self.historyStore = historyStore

        self.model = Model(
            title: "Start Page",
            urlHost: nil,
            fullURL: nil,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            showSearchSuggestions: false,
            canGoBack: false,
            canGoForward: false, 
            backList: nil,
            forwardList: nil)
    }

    public func didRequestSearch(_ text: String) {
        let url = URLBuilderAPI.makeURL(from: text)
        webView.load(url)
    }

    public func didSelectBackListPage(at index: Int) {
        didDismissNavigationList()
        webView.navigateToBackListPage(at: index)
    }

    public func didSelectForwardListPage(at index: Int) {
        didDismissNavigationList()
        webView.navigateToForwardListPage(at: index)
    }

    public func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelistStore.saveDomain(url)
        } else {
            safelistStore.removeDomain(url)
        }
    }

    public func didStartNewWindow() {
        delegate?.didUpdatePresentableModel(.init(
            title: "Start Page",
            urlHost: nil,
            fullURL: nil,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: false, 
            showSiteProtection: false,
            isWebsiteProtected: true,
            showWebView: false,
            showSearchSuggestions: false,
            canGoBack: false,
            canGoForward: false,
            backList: nil,
            forwardList: nil))
    }

    public func didChangeFocus(isFocused: Bool) {
        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: isFocused,
            showClearButton: isFocused,
            showStopButton: isFocused ? false : model.showStopButton,
            showReloadButton: isFocused ? false : model.showReloadButton,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: model.showWebView,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: nil,
            forwardList: nil)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didStartTyping(oldText: String, newText: String) {
        guard oldText != newText && newText != model.fullURL else { return }

        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: newText,
            showCancelButton: true,
            showClearButton: true,
            showStopButton: false,
            showReloadButton: false,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: model.showWebView,
            showSearchSuggestions: newText.isEmpty ? false : true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: nil,
            forwardList: nil)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didUpdateNavigationButton(canGoBack: Bool, canGoForward: Bool) {
        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: canGoBack,
            canGoForward: canGoForward,
            backList: model.backList,
            forwardList: model.forwardList)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didLoadPage(title: String?, url: URL) {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let title = title ?? urlHost

        let newModel = Model(
            title: title,
            urlHost: urlHost,
            fullURL: fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: false,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: !safelistStore.isRegisteredDomain(urlHost),
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: model.backList,
            forwardList: model.forwardList)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didLoadBackList() {
        let webPages = webView.retrieveBackList().map { WebPage(title: $0.title, url: $0.url, date: $0.date) }

        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: model.showCancelButton,
            showClearButton: model.showClearButton,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: webPages.map(mapWebPage).reversed(),
            forwardList: nil)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didLoadForwardList() {
        let webPages = webView.retrieveForwardList().map { WebPage(title: $0.title, url: $0.url, date: $0.date) }

        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: model.showCancelButton,
            showClearButton: model.showClearButton,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: nil,
            forwardList: webPages.map(mapWebPage))

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    public func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        delegate?.didUpdatePresentableModel(.init(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: false,
            showClearButton: false,
            showStopButton: value < 1 ? true : false,
            showReloadButton: value >= 1 ? true : false,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            progressBarValue: progressValue,
            backList: model.backList,
            forwardList: model.forwardList))
    }

    private func didDismissNavigationList() {
        let newModel = Model(
            title: model.title,
            urlHost: model.urlHost,
            fullURL: model.fullURL,
            showCancelButton: model.showCancelButton,
            showClearButton: model.showClearButton,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton,
            showSiteProtection: model.showSiteProtection,
            isWebsiteProtected: model.isWebsiteProtected,
            showWebView: true,
            showSearchSuggestions: false,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            backList: nil,
            forwardList: nil)

        model = newModel
        delegate?.didUpdatePresentableModel(newModel)
    }

    private func mapWebPage(_ webPage: WebPage) -> Model.Page {
        let title = webPage.title ?? ""
        return .init(title: title.isEmpty ? webPage.url.absoluteString : title, url: webPage.url.absoluteString)
    }
}

extension TabManager: WebEngineDelegate {
    public func didLoad(page: WebPage) {
        historyStore.save(HistoryPageModel(title: page.title, url: page.url, date: page.date))
        didLoadPage(title: page.title, url: page.url)
    }

    public func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        didUpdateNavigationButton(canGoBack: canGoBack, canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        didUpdateProgressBar(progress)
    }
}
