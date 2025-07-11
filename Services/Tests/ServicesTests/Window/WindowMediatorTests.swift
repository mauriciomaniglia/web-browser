import XCTest
@testable import Services

class WindowMediatorTests: XCTestCase {

    func test_didRequestSearch_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didStartTyping_sendsCorrectMessage() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didStartTyping(oldText: "app", newText: "apple")

        XCTAssertEqual(presenter.receivedMessages, [.didStartTyping(oldText: "app", newText: "apple")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didTapBackButton_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didTapBackButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapBackButton])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didTapForwardButton_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()
        sut.didTapForwardButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapForwardButton])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didLongPressBackButton_sendsCorrectMessage() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didLongPressBackButton()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadBackList])
        XCTAssertEqual(webView.receivedMessages, [.retrieveBackList])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didLongPressForwardButton_sendsCorrectMessage() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didLongPressForwardButton()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadForwardList])
        XCTAssertEqual(webView.receivedMessages, [.retrieveForwardList])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didLoadPage_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()
        let page = WebPage(title: "any", url: URL(string: "http://www.apple.com")!, date: Date())

        sut.didLoad(page: page)

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPage])
        XCTAssertEqual(history.receivedMessages, [])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didUpdateNavigationButtons_sendsCorrectMessage() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertEqual(presenter.receivedMessages, [.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didUpdateLoadingProgress_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didUpdateLoadingProgress(0.5)

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didUpdateProgressBar(value: 0.5)])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didSelectBackListPage_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didSelectBackListPage(at: 1)

        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
        XCTAssertEqual(webView.receivedMessages, [.navigateToBackListPage])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didSelectForwardListPage_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didSelectForwardListPage(at: 1)

        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
        XCTAssertEqual(webView.receivedMessages, [.navigateToForwardListPage])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_didDismissBackForwardList_sendsCorrectMessages() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didDismissBackForwardList()

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_updateSafelist_withURLEnabled_addURLToSafelist() {
        let (sut, webView, presenter, safelist, history) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    func test_updateSafelist_withURLDisabled_removesURLFromSafelist() {
        let (sut, webView, presenter, safelist, history) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: WindowMediator,
                               webView: WebViewSpy,
                               presenter: WindowPresenterSpy,
                               safelist: SafelistStoreSpy,
                               historyStore: HistoryStoreMock)
    {
        let webView = WebViewSpy()
        let safelist = SafelistStoreSpy()
        let historyStore = HistoryStoreMock()
        let presenter = WindowPresenterSpy(isOnSafelist: safelist.isRegisteredDomain(_:))
        let sut = WindowMediator(
            webView: webView,
            presenter: presenter,
            safelistStore: safelist,
            historyStore: historyStore)

        return (sut, webView, presenter, safelist, historyStore)
    }
}
