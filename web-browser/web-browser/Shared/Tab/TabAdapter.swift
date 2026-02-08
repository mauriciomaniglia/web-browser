import Foundation
import Services

class TabAdapter {
    let tabID: UUID
    weak var tabViewModel: TabViewModel?
    let tabManager: TabManager<WebKitEngineWrapper, SafelistStore, HistorySwiftDataStore>
    let userActionDelegate: TabUserActionDelegate?

    init(
        tabID: UUID,
        tabViewModel: TabViewModel,
        tabManager: TabManager<WebKitEngineWrapper, SafelistStore, HistorySwiftDataStore>,
        userActionDelegate: TabUserActionDelegate?
    ) {
        self.tabID = tabID
        self.tabViewModel = tabViewModel
        self.tabManager = tabManager
        self.userActionDelegate = userActionDelegate
    }

    func didChangeFocus(isFocused: Bool) {
        let updatedModel = tabManager.didChangeFocus(isFocused: isFocused)
        didUpdatePresentableModel(updatedModel)
    }

    func didStartTyping(oldText: String, newText: String) {
        if let updateModel = tabManager.didStartTyping(oldText: oldText, newText: newText) {
            didUpdatePresentableModel(updateModel)
        }
    }

    func didLoadBackList() {
        let updatedModel = tabManager.didLoadBackList()
        didUpdatePresentableModel(updatedModel)
    }

    func didLoadForwardList() {
        let updatedModel = tabManager.didLoadForwardList()
        didUpdatePresentableModel(updatedModel)
    }

    func didSelectBackListPage(at index: Int) {
        let updatedModel = tabManager.didSelectBackListPage(at: index)
        didUpdatePresentableModel(updatedModel)
    }

    func didSelectForwardListPage(at index: Int) {
        let updatedModel = tabManager.didSelectForwardListPage(at: index)
        didUpdatePresentableModel(updatedModel)
    }

    func didDismissNavigationList() {
        let updatedModel = tabManager.didDismissNavigationList()
        didUpdatePresentableModel(updatedModel)
    }

    func didUpdatePresentableModel(_ model: PresentableTab) {
        guard let tabViewModel else { return }

        tabViewModel.isBackButtonDisabled = !model.canGoBack
        tabViewModel.isForwardButtonDisabled = !model.canGoForward
        tabViewModel.showCancelButton = model.showCancelButton
        tabViewModel.showStopButton = model.showStopButton
        tabViewModel.showReloadButton = model.showReloadButton
        tabViewModel.showClearButton = model.showClearButton
        tabViewModel.progressBarValue = model.progressBarValue
        tabViewModel.title = model.title ?? ""
        tabViewModel.urlHost = model.urlHost ?? ""
        tabViewModel.fullURL = model.fullURL ?? ""
        tabViewModel.isWebsiteProtected = model.isWebsiteProtected
        tabViewModel.showSiteProtection = model.showSiteProtection
        tabViewModel.showWebView = model.showWebView
        tabViewModel.showSearchSuggestions = model.showSearchSuggestions
        tabViewModel.backList = model.backList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        tabViewModel.showBackList = model.backList != nil
        tabViewModel.forwardList = model.forwardList?.compactMap { .init(title: $0.title, url: $0.url) } ?? []
        tabViewModel.showForwardList = model.forwardList != nil
    }
}

extension TabAdapter: WebEngineDelegate {
    public func didLoad(page: WebPageModel) {
        let updatedModel = tabManager.didLoad(page: page)
        didUpdatePresentableModel(updatedModel)

        userActionDelegate?.didLoadPage(tabID: tabID)
    }

    public func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        let updatedModel = tabManager.didUpdateNavigationButton(canGoBack: canGoBack, canGoForward: canGoForward)
        didUpdatePresentableModel(updatedModel)
    }

    public func didUpdateLoadingProgress(_ progress: Double) {
        let updatedModel = tabManager.didUpdateProgressBar(progress)
        didUpdatePresentableModel(updatedModel)
    }
}
