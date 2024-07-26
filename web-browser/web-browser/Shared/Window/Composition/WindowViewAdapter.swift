import Foundation
import core_web_browser

final class WindowViewAdapter {
    let viewModel: WindowViewModel

    init(viewModel: WindowViewModel) {
        self.viewModel = viewModel
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
