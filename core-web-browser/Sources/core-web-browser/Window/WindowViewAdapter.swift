import Foundation

public final class WindowViewAdapter: WindowViewContract {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI

    public init(webView: WebEngineContract, presenter: WindowPresenter, safelist: SafelistAPI) {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
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

    public func didStopLoading() {
        webView.stopLoading()
    }

    public func didTapBackButton() {
        webView.didTapBackButton()
    }

    public func didTapForwardButton() {
        webView.didTapForwardButton()
    }

    public func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelist.saveDomain(url)
        } else {
            safelist.removeDomain(url)
        }
    }
}

extension WindowViewAdapter: WebEngineDelegate {
    public func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        presenter.didLoadPage(
            url: url,            
            canGoBack: canGoBack,
            canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
