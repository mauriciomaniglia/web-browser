import Foundation

public final class TabMediator {
    private let webView: WebEngineContract
    private let presenter: TabPresenter
    private let safelistStore: SafelistStoreAPI
    private let historyStore: HistoryStoreAPI

    public init(webView: WebEngineContract,
                presenter: TabPresenter,
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

    public func didLongPressBackButton() {
        let webPages = webView.retrieveBackList().map { PageModel(title: $0.title, url: $0.url, date: $0.date) }
        presenter.didLoadBackList(webPages)
    }

    public func didLongPressForwardButton() {
        let webPages = webView.retrieveForwardList().map { PageModel(title: $0.title, url: $0.url, date: $0.date) }
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

    public func updateSafelist(url: String, isEnabled: Bool) {
        if isEnabled {
            safelistStore.saveDomain(url)
        } else {
            safelistStore.removeDomain(url)
        }
    }
}

extension TabMediator: WebEngineDelegate {
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
