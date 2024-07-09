import Foundation
import core_web_browser

final class WindowViewAdapter {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI
    private let history: HistoryAPI
    let viewModel: WindowViewModel

    init(webView: WebEngineContract, presenter: WindowPresenter, safelist: SafelistAPI, history: HistoryAPI, viewModel: WindowViewModel) {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
        self.history = history
        self.viewModel = viewModel
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

    func updateViewModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.showMenuButton = model.showMenuButton
        viewModel.showCancelButton = model.showCancelButton
        viewModel.showStopButton = model.showStopButton
        viewModel.showReloadButton = model.showReloadButton
        viewModel.showClearButton = model.showClearButton
        viewModel.progressBarValue = model.progressBarValue
        viewModel.urlHost = model.urlHost
        viewModel.fullURL = model.fullURL ?? ""
        viewModel.isWebsiteProtected = model.isWebsiteProtected
        viewModel.showSiteProtection = model.showSiteProtection
        viewModel.backList = model.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        viewModel.showBackList = model.backList != nil
        viewModel.forwardList = model.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        viewModel.showForwardList = model.forwardList != nil
    }
}

extension WindowViewAdapter: WebEngineDelegate {
    func didLoad(page: WebPage) {

    }

    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        presenter.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward)
    }

    func didLoad(page: WebPage, canGoBack: Bool, canGoForward: Bool) {
        history.save(page: page)
        presenter.didLoadPage(url: page.url)
    }

    func didUpdateLoadingProgress(_ progress: Double) {
        presenter.didUpdateProgressBar(progress)
    }
}
