import XCTest
@testable import web_browser
@testable import core_web_browser

class WindowViewAdapterTests: XCTestCase {

    func test_didRequestSearch_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    func test_didReload_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didReload()

        XCTAssertEqual(webView.receivedMessages, [.reload])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    func test_didStartEditing_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didStartEditing()

        XCTAssertEqual(presenter.receivedMessages, [.didStartEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didEndEditing_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didEndEditing()

        XCTAssertEqual(presenter.receivedMessages, [.didEndEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didStopLoading_sendsCorrectMessage() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didStopLoading()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.stopLoading])
    }

    func test_didTapBackButton_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didTapBackButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapBackButton])
    }

    func test_didTapForwardButton_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didTapForwardButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapForwardButton])
    }

    func test_didLongPressBackButton_sendsCorrectMessage() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didLongPressBackButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.retrieveBackList])
    }

    func test_didLoadPage_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didLoadPage(url: URL(string: "http://www.apple.com")!, canGoBack: true, canGoForward: false)

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPage(canGoBack: true, canGoForward: false)])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didUpdateLoadingProgress_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didUpdateLoadingProgress(0.5)

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didUpdateProgressBar(value: 0.5)])
    }

    func test_updateSafelist_withURLEnabled_addURLToSafelist() {
        let (sut, _, _, safelist) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain(url)])
    }

    func test_updateSafelist_withURLDisabled_removesURLFromSafelist() {
        let (sut, _, _, safelist) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain(url)])
    }

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let (sut, _, _, _) = makeSUT()
        let model = WindowPresentableModel(
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

        XCTAssertEqual(sut.viewModel.urlHost, model.urlHost)
        XCTAssertEqual(sut.viewModel.fullURL, model.fullURL)
        XCTAssertEqual(sut.viewModel.showCanceButton, model.showCancelButton)
        XCTAssertEqual(sut.viewModel.showStopButton, model.showStopButton)
        XCTAssertEqual(sut.viewModel.showReloadButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showClearButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showSiteProtection, model.showSiteProtection)
        XCTAssertEqual(sut.viewModel.isWebsiteProtected, model.isWebsiteProtected)
        XCTAssertEqual(sut.viewModel.isBackButtonDisabled, !model.canGoBack)
        XCTAssertEqual(sut.viewModel.isForwardButtonDisabled, !model.canGoForward)
        XCTAssertEqual(sut.viewModel.progressBarValue, model.progressBarValue)
        XCTAssertEqual(sut.viewModel.backList?.first?.title, model.backList?.first?.title)
        XCTAssertEqual(sut.viewModel.backList?.first?.url, model.backList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
        XCTAssertEqual(sut.viewModel.forwardList?.first?.title, model.forwardList?.first?.title)
        XCTAssertEqual(sut.viewModel.forwardList?.first?.url, model.forwardList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: WindowViewAdapter, webView: WebViewSpy, presenter: WindowPresenterSpy, safelist: SafelistStoreSpy) {
        let webView = WebViewSpy()
        let presenter = WindowPresenterSpy()
        let safelist = SafelistStoreSpy()
        let viewModel = WindowViewModel()
        let sut = WindowViewAdapter(webView: webView, presenter: presenter, safelist: safelist, viewModel: viewModel)

        return (sut, webView, presenter, safelist)
    }
}
