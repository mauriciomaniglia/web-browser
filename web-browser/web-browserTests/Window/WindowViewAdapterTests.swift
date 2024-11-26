import XCTest
@testable import web_browser
@testable import Services

class WindowViewAdapterTests: XCTestCase {

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, _, _) = makeSUT()
        let model = WindowPresentableModel(
            title: "Apple Airpods",
            urlHost: "www.apple.com",
            fullURL: "http://apple.com/airpods",
            showCancelButton: true,
            showClearButton: true,
            showStopButton: true,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: true,
            showWebView: true,
            canGoBack: true,
            canGoForward: true,
            progressBarValue: 0.5, 
            backList: [WindowPresentableModel.WebPage(title: "back page title", url: "http://back-page.com")],
            forwardList: [WindowPresentableModel.WebPage(title: "forward page title", url: "http://forward-page.com")])

        sut.updateViewModel(model)

        XCTAssertEqual(sut.viewModel.title, model.title)
        XCTAssertEqual(sut.viewModel.urlHost, model.urlHost)
        XCTAssertEqual(sut.viewModel.fullURL, model.fullURL)
        XCTAssertEqual(sut.viewModel.showStopButton, model.showStopButton)
        XCTAssertEqual(sut.viewModel.showReloadButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showClearButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showSiteProtection, model.showSiteProtection)
        XCTAssertEqual(sut.viewModel.isWebsiteProtected, model.isWebsiteProtected)
        XCTAssertEqual(sut.viewModel.isBackButtonDisabled, !model.canGoBack)
        XCTAssertEqual(sut.viewModel.isForwardButtonDisabled, !model.canGoForward)
        XCTAssertEqual(sut.viewModel.progressBarValue, model.progressBarValue)
        XCTAssertEqual(sut.viewModel.backList.first?.title, model.backList?.first?.title)
        XCTAssertEqual(sut.viewModel.backList.first?.url, model.backList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
        XCTAssertEqual(sut.viewModel.forwardList.first?.title, model.forwardList?.first?.title)
        XCTAssertEqual(sut.viewModel.forwardList.first?.url, model.forwardList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
    }

    func test_saveDomainToSafeList_sendsCorrectMessages() {
        let (sut, history, safelist) = makeSUT()

        sut.saveDomainToSafeList("www.my-domain.com")

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain("www.my-domain.com")])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_removeDomainFromSafeList_sendsCorrectMessages() {
        let (sut, history, safelist) = makeSUT()

        sut.removeDomainFromSafeList("www.my-domain.com")

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain("www.my-domain.com")])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_saveToHistory_sendsCorrectMessages() {
        let (sut, history, safelist) = makeSUT()
        let page = WebPage(title: nil, url: URL(string: "www.my-domain.com")!, date: Date())

        sut.saveToHistory(page)

        XCTAssertEqual(history.receivedMessages, [.save(page.url)])
        XCTAssertEqual(safelist.receivedMessages, [])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: WindowViewAdapter, history: HistoryStoreSpy, safelist: SafelistStoreSpy) {
        let viewModel = WindowViewModel(historyViewModel: HistoryViewModel(), bookmarkViewModel: BookmarkViewModel())
        let historySpy = HistoryStoreSpy()
        let safelistSpy = SafelistStoreSpy()
        let sut = WindowViewAdapter(webView: WebViewSpy(),
                                    viewModel: viewModel,
                                    bookmarkViewModel: BookmarkViewModel(),
                                    history: historySpy,
                                    safelist: safelistSpy)
        return (sut, historySpy, safelistSpy)
    }
}

private class HistoryStoreSpy: HistoryAPI {
    enum Message: Equatable {
        case save(_ url: URL)
        case getPages
        case deletePages
        case deleteAllPages
    }

    var receivedMessages = [Message]()

    func save(_ page: WebPage) {
        receivedMessages.append(.save(page.url))
    }

    func getPages() -> [WebPage] {
        receivedMessages.append(.getPages)
        return []
    }

    func getPages(by searchTerm: String) -> [WebPage] {
        return []
    }

    func deletePages(withIDs ids: [UUID]) {
        receivedMessages.append(.deletePages)
    }

    func deleteAllPages() {
        receivedMessages.append(.deleteAllPages)
    }
}

class SafelistStoreSpy: SafelistAPI {
    enum Message: Equatable {
        case isRegisteredDomain(_ domain: String)
        case fetchRegisteredDomains
        case saveDomain(_ domain: String)
        case removeDomain(_ domain: String)
    }

    var receivedMessages = [Message]()
    var isOnSafelist = false

    func isRegisteredDomain(_ domain: String) -> Bool {
        receivedMessages.append(.isRegisteredDomain(domain))
        return isOnSafelist
    }

    func fetchRegisteredDomains() -> [String] {
        receivedMessages.append(.fetchRegisteredDomains)
        return []
    }

    func saveDomain(_ domain: String) {
        receivedMessages.append(.saveDomain(domain))
    }

    func removeDomain(_ domain: String) {
        receivedMessages.append(.removeDomain(domain))
    }
}
