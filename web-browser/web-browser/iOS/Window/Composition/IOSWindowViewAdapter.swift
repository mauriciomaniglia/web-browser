import Foundation
import core_web_browser

final class IOSWindowViewAdapter {
    private let webView: WebEngineContract
    private let presenter: WindowPresenter
    private let safelist: SafelistAPI
    let viewModel: WindowViewModel

    init(webView: WebEngineContract, presenter: WindowPresenter, safelist: SafelistAPI, viewModel: WindowViewModel) {
        self.webView = webView
        self.presenter = presenter
        self.safelist = safelist
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
        viewModel.showStopButton = model.showStopButton
        viewModel.showReloadButton = model.showReloadButton
        viewModel.showClearButton = model.showClearButton
        viewModel.progressBarValue = model.progressBarValue
        viewModel.urlHost = model.urlHost
        viewModel.fullURL = model.fullURL ?? ""
        viewModel.isWebsiteProtected = model.isWebsiteProtected
        viewModel.showSiteProtection = model.showSiteProtection
    }
}

extension IOSWindowViewAdapter: WebEngineDelegate {
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