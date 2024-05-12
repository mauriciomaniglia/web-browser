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

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPage(isOnWhitelist: false, canGoBack: true, canGoForward: false)])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didUpdateLoadingProgress_sendsCorrectMessages() {
        let (sut, webView, presenter, _) = makeSUT()

        sut.didUpdateLoadingProgress(0.5)

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didUpdateProgressBar(value: 0.5)])
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

private class WindowPresenterSpy: WindowPresenter {
    enum Message: Equatable {
        case didStartEditing
        case didEndEditing
        case didLoadPage(isOnWhitelist: Bool?, canGoBack: Bool, canGoForward: Bool)
        case didUpdateProgressBar(value: Double)
    }

    var receivedMessages = [Message]()

    override func didStartEditing() {
        receivedMessages.append(.didStartEditing)
    }

    override func didEndEditing() {
        receivedMessages.append(.didEndEditing)
    }

    override func didLoadPage(url: String, isOnWhitelist: Bool?, canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didLoadPage(isOnWhitelist: isOnWhitelist, canGoBack: canGoBack, canGoForward: canGoForward))
    }

    override func didUpdateProgressBar(_ value: Double) {
        receivedMessages.append(.didUpdateProgressBar(value: value))
    }
}

private class WhitelistStoreSpy: WhitelistAPI {
    func isRegisteredDomain(_ domain: String) -> Bool {
        return false
    }
    
    func fetchRegisteredDomains() -> [String] {
        return []
    }
    
    func saveDomain(_ domain: String) {
        
    }
    
    func removeDomain(_ domain: String) {

    }
}
