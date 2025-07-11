import Foundation

public final class WindowMediator {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelistStore: SafelistStoreAPI
    private let historyStore: HistoryStoreAPI

    public init(webView: WebEngineContract,
                presenter: WindowPresenter,
                safelistStore: SafelistStoreAPI,
                historyStore: HistoryStoreAPI)
    {
        self.webView = webView
        self.presenter = presenter
        self.safelistStore = safelistStore
        self.historyStore = historyStore
    }

    public func didRequestSearch(_ text: String) {
        let url = URLBuilderAPI.makeURL(from: text)
        webView.load(url)
    }

    public func didTapBackButton() {
        webView.didTapBackButton()
    }

    public func didTapForwardButton() {
        webView.didTapForwardButton()
    }

    public func didLongPressBackButton() {
        let webPages = webView.retrieveBackList().map { WindowPageModel(title: $0.title, url: $0.url, date: $0.date) }
        presenter.didLoadBackList(webPages)
    }

    public func didLongPressForwardButton() {
        let webPages = webView.retrieveForwardList().map { WindowPageModel(title: $0.title, url: $0.url, date: $0.date) }
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
            safelistStore.saveDomain(url)
        } else {
            safelistStore.removeDomain(url)
        }
    }
}

extension WindowMediator: WebEngineDelegate {
    public func didLoad(page: WebPage) {
        historyStore.save(HistoryPageModel(title: page.title, url: page.url, date: page.date))
        presenter.didLoadPage(title: page.title, url: page.url)
    }

    public func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        presenter.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
