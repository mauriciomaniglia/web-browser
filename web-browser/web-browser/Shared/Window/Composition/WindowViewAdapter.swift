import Foundation
import Services

final class WindowViewAdapter {
    let webView: WebEngineContract
    let viewModel: WindowViewModel
    let bookmarkViewModel: BookmarkViewModel
    let history: HistoryAPI
    let safelist: SafelistAPI

    init(webView: WebEngineContract,
         viewModel: WindowViewModel,
         bookmarkViewModel: BookmarkViewModel,
         history: HistoryAPI,
         safelist: SafelistAPI)
    {
        self.webView = webView
        self.viewModel = viewModel
        self.bookmarkViewModel = bookmarkViewModel
        self.history = history
        self.safelist = safelist
    }

    func updateViewModel(_ model: WindowPresentableModel) {
        viewModel.isBackButtonDisabled = !model.canGoBack
        viewModel.isForwardButtonDisabled = !model.canGoForward
        viewModel.showCancelButton = model.showCancelButton
        viewModel.showStopButton = model.showStopButton
        viewModel.showReloadButton = model.showReloadButton
        viewModel.showClearButton = model.showClearButton
        viewModel.progressBarValue = model.progressBarValue
        viewModel.title = model.title ?? ""
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

extension WindowViewAdapter: WindowFacadeDelegate {
    func saveDomainToSafeList(_ domain: String) {
        safelist.saveDomain(domain)
    }
    
    func removeDomainFromSafeList(_ domain: String) {
        safelist.removeDomain(domain)
    }
    
    func saveToHistory(_ page: WebPage) {
        history.save(page)
    }
}
