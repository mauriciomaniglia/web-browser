import Foundation
import Core

final class WindowViewAdapter {
    let webView: WebEngineContract
    let viewModel: WindowViewModel
    let bookmarkViewModel: BookmarkViewModel

    init(webView: WebEngineContract, viewModel: WindowViewModel, bookmarkViewModel: BookmarkViewModel) {
        self.webView = webView
        self.viewModel = viewModel
        self.bookmarkViewModel = bookmarkViewModel
    }

    func updateViewModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
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

    func didTapAddBookmark() {
        if let currentPage = webView.getCurrentPage() {
            bookmarkViewModel.didTapSavePage?(currentPage.title ?? "", currentPage.url)
        }
    }
}
