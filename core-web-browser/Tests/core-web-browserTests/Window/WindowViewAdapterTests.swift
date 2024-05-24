import XCTest
@testable import core_web_browser

class WindowViewAdapterTests: XCTestCase {

    func test_didRequestSearch_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    func test_didStartTyping_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didStartTyping()

        XCTAssertEqual(presenter.receivedMessages, [.didStartEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didEndTyping_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didEndTyping()

        XCTAssertEqual(presenter.receivedMessages, [.didEndEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_stopLoading_sendsCorrectMessage() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.stopLoading()

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

    func test_updateWhitelist_withURLEnabled_addURLToWhitelist() {
        let (sut, _, _, whitelist) = makeSUT()
        let url = "http://some-url.com"

        sut.updateWhitelist(url: url, isEnabled: true)

        XCTAssertEqual(whitelist.receivedMessages, [.saveDomain(url)])
    }

    func test_updateWhitelist_withURLDisabled_removesURLFromWhitelist() {
        let (sut, _, _, whitelist) = makeSUT()
        let url = "http://some-url.com"

        sut.updateWhitelist(url: url, isEnabled: false)

        XCTAssertEqual(whitelist.receivedMessages, [.removeDomain(url)])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: WindowViewAdapter, webView: WebViewSpy, presenter: WindowPresenterSpy, whitelist: WhitelistStoreSpy) {
        let webView = WebViewSpy()
        let presenter = WindowPresenterSpy()
        let whitelist = WhitelistStoreSpy()
        let sut = WindowViewAdapter(webView: webView, presenter: presenter, whitelist: whitelist)

        return (sut, webView, presenter, whitelist)
    }
}
