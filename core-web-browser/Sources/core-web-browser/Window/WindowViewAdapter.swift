import Foundation

public final class WindowViewAdapter: WindowViewContract {
    private let webView: WebViewContract
    private let presenter: WindowPresenter
    private let whitelist: WhitelistAPI

    public init(webView: WebViewContract, presenter: WindowPresenter, whitelist: WhitelistAPI) {
        self.webView = webView
        self.presenter = presenter
        self.whitelist = whitelist
    }

    public func didRequestSearch(_ text: String) {
        webView.load(SearchURLBuilder.makeURL(from: text))
    }

    public func didStartTyping() {
        presenter.didStartEditing()
    }

    public func didEndTyping() {
        presenter.didEndEditing()
    }

    public func didTapBackButton() {
        webView.didTapBackButton()
    }

    public func didTapForwardButton() {
        webView.didTapForwardButton()
    }

    public func updateWhitelist(url: String, isEnabled: Bool) {

    }
}

extension WindowViewAdapter: WebViewProxyDelegate {
    public func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        let isOnWhitelist = WhitelistStore().isRegisteredDomain(url.absoluteString)
        presenter.didLoadPage(
            url: url.absoluteString,
            isOnWhitelist: isOnWhitelist,
            canGoBack: canGoBack,
            canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
