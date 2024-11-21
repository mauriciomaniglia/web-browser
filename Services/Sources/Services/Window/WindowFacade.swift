import Foundation

public final class WindowFacade {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI
    private let history: HistoryAPI
    private let urlBuilder: (String) -> URL

    public init(webView: WebEngineContract,
                presenter: WindowPresenter,
                safelist: SafelistAPI,
                history: HistoryAPI,
                urlBuilder: @escaping (String) -> URL)
    {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
        self.history = history
        self.urlBuilder = urlBuilder
    }

    public func didRequestSearch(_ text: String) {
        let url = urlBuilder(text)
        webView.load(url)
    }

    public func didReload() {
        webView.reload()
    }

    public func didStartEditing() {
        presenter.didStartEditing()
    }

    public func didEndEditing() {
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

    public func didLongPressBackButton() {
        let webPages = webView.retrieveBackList()
        presenter.didLoadBackList(webPages)
    }

    public func didLongPressForwardButton() {
        let webPages = webView.retrieveForwardList()
        presenter.didLoadForwardList(webPages)
    }

    public func didSelectBackListPage(at index: Int) {
        presenter.didDismissBackForwardList()
        webView.navigateToBackListPage(at: index)
    }

    public func didSelectForwardListPage(at index: Int) {
        presenter.didDismissBackForwardList()
        webView.navigateToForwardListPage(at: index)
    }

    public func didDismissBackForwardList() {
        presenter.didDismissBackForwardList()
    }

    public func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelist.saveDomain(url)
        } else {
            safelist.removeDomain(url)
        }
    }
}

extension WindowFacade: WebEngineDelegate {
    public func didLoad(page: WebPage) {
        history.save(page)
        presenter.didLoadPage(title: page.title, url: page.url)
    }

    public func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        presenter.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
