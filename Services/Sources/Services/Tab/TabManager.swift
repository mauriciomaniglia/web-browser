import Foundation

@MainActor
public protocol TabManagerAPI {
    func didLoad(page: WebPageModel) -> TabViewData
    func didRequestSearch(_ text: String)
    func didChangeFocus(isFocused: Bool) -> TabViewData
    func didStartTyping(oldText: String, newText: String) -> TabViewData?
    func didLoadBackList() -> TabViewData
    func didLoadForwardList() -> TabViewData
    func didSelectBackListPage(at index: Int) -> TabViewData
    func didSelectForwardListPage(at index: Int) -> TabViewData
    func didDismissNavigationList() -> TabViewData
    func didUpdateProgressBar(_ value: Double) -> TabViewData
    func updateSafelist(url: String, isEnabled: Bool)
}

@MainActor
public class TabManager<W: WebEngineContract, S: SafelistStoreAPI, H: HistoryStoreAPI>: TabManagerAPI {
    private let webView: W
    private let safelistStore: S
    private let historyStore: H
    private var model: TabViewData

    public init(webView: W, safelistStore: S, historyStore: H) {
        self.webView = webView
        self.safelistStore = safelistStore
        self.historyStore = historyStore

        self.model = TabViewData(
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

    public func didLoad(page: WebPageModel) -> TabViewData {
        historyStore.save(WebPageModel(title: page.title, url: page.url, date: page.date))
        return didLoadPage(title: page.title, url: page.url)
    }

    public func didSelectBackListPage(at index: Int) -> TabViewData {
        webView.navigateToBackListPage(at: index)
        return didDismissNavigationList()
    }

    public func didSelectForwardListPage(at index: Int) -> TabViewData {
        webView.navigateToForwardListPage(at: index)
        return didDismissNavigationList()
    }

    public func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelistStore.saveDomain(url)
        } else {
            safelistStore.removeDomain(url)
        }
    }

    public func didStartNewWindow() -> TabViewData {
        return TabViewData(
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

    public func didChangeFocus(isFocused: Bool) -> TabViewData {
        model = TabViewData(
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

        return model
    }

    public func didStartTyping(oldText: String, newText: String) -> TabViewData? {
        guard !newText.isEmpty else { return nil }
        guard  oldText != newText && newText != model.fullURL else { return nil }

        model = TabViewData(
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

        return model
    }

    public func didUpdateNavigationButton(canGoBack: Bool, canGoForward: Bool) -> TabViewData {
        model = TabViewData(
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

        return model
    }

    public func didLoadPage(title: String?, url: URL) -> TabViewData {
        let fullURL = url.absoluteString
        let urlHost = url.host ?? fullURL
        let title = title ?? urlHost

        model = TabViewData(
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
            canGoBack: !webView.retrieveBackList().isEmpty,
            canGoForward: !webView.retrieveForwardList().isEmpty,
            backList: model.backList,
            forwardList: model.forwardList)

        return model
    }

    public func didLoadBackList() -> TabViewData {
        let webPages = webView.retrieveBackList().map { WebPageModel(title: $0.title, url: $0.url, date: $0.date) }

        model = TabViewData(
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

        return model
    }

    public func didLoadForwardList() -> TabViewData {
        let webPages = webView.retrieveForwardList().map { WebPageModel(title: $0.title, url: $0.url, date: $0.date) }

        model = TabViewData(
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

        return model
    }

    public func didUpdateProgressBar(_ value: Double) -> TabViewData {
        let progressValue = value >= 1 ? nil : value

        return TabViewData(
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
            forwardList: model.forwardList)
    }

    public func didDismissNavigationList() -> TabViewData {
        model = TabViewData(
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

        return model
    }

    private func mapWebPage(_ webPage: WebPageModel) -> TabViewData.Page {
        let title = webPage.title ?? ""
        return .init(title: title.isEmpty ? webPage.url.absoluteString : title, url: webPage.url.absoluteString)
    }
}

public struct TabViewData {
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
