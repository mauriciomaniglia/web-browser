import Foundation
import core_web_browser

final class WindowViewAdapter {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI

    init(webView: WebEngineContract, presenter: WindowPresenter, safelist: SafelistAPI) {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
    }

    func didRequestSearch(_ text: String) {
        webView.load(SearchURLBuilder.makeURL(from: text))
    }

    func didReload() {
        webView.reload()
    }

    func didStartTyping() {
        presenter.didStartEditing()
    }

    func didEndTyping() {
        presenter.didEndEditing()
    }

    func didStopLoading() {
        webView.stopLoading()
    }

    func didTapBackButton() {
        webView.didTapBackButton()
    }

    func didTapForwardButton() {
        webView.didTapForwardButton()
    }

    func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelist.saveDomain(url)
        } else {
            safelist.removeDomain(url)
        }
    }
}

extension WindowViewAdapter: WebEngineDelegate {
    func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        presenter.didLoadPage(
            url: url,            
            canGoBack: canGoBack,
            canGoForward: canGoForward)
    }

    func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
