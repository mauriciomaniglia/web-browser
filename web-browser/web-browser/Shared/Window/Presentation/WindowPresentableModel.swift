struct WindowPresentableModel {

    struct WebPage {
        let title: String
        let url: String
    }

    let urlHost: String?
    let fullURL: String?
    let showCancelButton: Bool
    let showClearButton: Bool
    let showStopButton: Bool
    let showReloadButton: Bool
    let showSiteProtection: Bool
    let isWebsiteProtected: Bool
    let showWebView: Bool
    let canGoBack: Bool
    let canGoForward: Bool
    var progressBarValue: Double?
    let backForwardList: [WebPage]?
}
