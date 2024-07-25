import Foundation
import core_web_browser

final class WindowFacade {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI
    private let history: HistoryAPI

    init(webView: WebEngineContract, presenter: WindowPresenter, safelist: SafelistAPI, history: HistoryAPI) {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
        self.history = history        
    }

    func didRequestSearch(_ text: String) {
        webView.load(SearchURLBuilder.makeURL(from: text))
    }

    func didReload() {
        webView.reload()
    }

    func didStartEditing() {
        presenter.didStartEditing()
    }

    func didEndEditing() {
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

    func didLongPressBackButton() {
        let webPages = webView.retrieveBackList()
        presenter.didLoadBackList(webPages)
    }

    func didLongPressForwardButton() {
        let webPages = webView.retrieveForwardList()
        presenter.didLoadForwardList(webPages)
    }

    func didSelectBackListPage(at index: Int) {
        presenter.didDismissBackForwardList()
        webView.navigateToBackListPage(at: index)
    }

    func didSelectForwardListPage(at index: Int) {
        presenter.didDismissBackForwardList()
        webView.navigateToForwardListPage(at: index)
    }

    func didDismissBackForwardList() {
        presenter.didDismissBackForwardList()
    }

    func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelist.saveDomain(url)
        } else {
            safelist.removeDomain(url)
        }
    }
}

extension WindowFacade: WebEngineDelegate {
    func didLoad(page: WebPage) {
        history.save(page: page)
        presenter.didLoadPage(url: page.url)
    }

    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        presenter.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward)
    }

    func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
