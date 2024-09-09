public struct WindowPresentableModel {

    public struct WebPage {
        public let title: String
        public let url: String
    }

    public let urlHost: String?
    public let fullURL: String?
    public let showCancelButton: Bool
    public let showClearButton: Bool
    public let showStopButton: Bool
    public let showReloadButton: Bool
    public let showSiteProtection: Bool
    public let isWebsiteProtected: Bool
    public let showWebView: Bool
    public let canGoBack: Bool
    public let canGoForward: Bool
    public var progressBarValue: Double?
    public let backList: [WebPage]?
    public let forwardList: [WebPage]?
}
