import Foundation

public final class WindowViewAdapter: WindowViewContract {
    private let webView: WebViewContract
    private let presenter: WindowPresenter

    public init(webView: WebViewContract, presenter: WindowPresenter) {
        self.webView = webView
        self.presenter = presenter
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
}

extension WindowViewAdapter: WebViewProxyDelegate {
    public func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        let isOnWhitelist = WhitelistStore.isRegisteredDomain(url.absoluteString)
        presenter.didLoadPage(isOnWhitelist: isOnWhitelist, canGoBack: canGoBack, canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
