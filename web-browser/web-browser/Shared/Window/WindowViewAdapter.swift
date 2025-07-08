import Foundation
import Services

final class WindowViewAdapter {
    let webView: WebEngineContract
    let viewModel: WindowViewModel

    init(webView: WebEngineContract, viewModel: WindowViewModel) {
        self.webView = webView
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: WindowPresenter.Model) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.showCancelButton = model.showCancelButton
        viewModel.showStopButton = model.showStopButton
        viewModel.showReloadButton = model.showReloadButton
        viewModel.showClearButton = model.showClearButton
        viewModel.progressBarValue = model.progressBarValue
        viewModel.title = model.title ?? ""
        viewModel.urlHost = model.urlHost ?? ""
        viewModel.fullURL = model.fullURL ?? ""
        viewModel.isWebsiteProtected = model.isWebsiteProtected
        viewModel.showSiteProtection = model.showSiteProtection
        viewModel.showWebView = model.showWebView
        viewModel.showSearchSuggestions = model.showSearchSuggestions
        viewModel.backList = model.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        viewModel.showBackList = model.backList != nil
        viewModel.forwardList = model.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        viewModel.showForwardList = model.forwardList != nil
    }
}
