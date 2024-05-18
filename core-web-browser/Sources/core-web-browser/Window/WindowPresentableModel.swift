public struct WindowPresentableModel {
    public let pageURL: String?
    public let showCancelButton: Bool
    public let showStopButton: Bool
    public let showReloadButton: Bool
    public let showSiteProtection: Bool
    public let isWebsiteProtected: Bool
    public let showWebView: Bool
    public let canGoBack: Bool
    public let canGoForward: Bool
    public var progressBarValue: Double?
}
