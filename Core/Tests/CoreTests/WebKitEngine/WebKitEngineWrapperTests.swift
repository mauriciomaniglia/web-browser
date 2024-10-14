import XCTest
import WebKit
import Core

class WebKitEngineWrapperTests: XCTestCase {
    let navigation = WKNavigation()

    func test_init_doesNotSendAnyMessage() {
        let (_, _, _, delegate) = makeSUT()

        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_init_registerCorrectObserversForWebViewEvents() {
        let (_, webView, _, _) = makeSUT()

        XCTAssertEqual(webView.registeredObservers, ["title", "URL", "canGoBack", "canGoForward", "estimatedProgress"])
    }

    func test_sendText_sendsCorrectRequest() {
        let (sut, webView, _, _) = makeSUT()        

        sut.load(URL(string: "https://openai.com")!)

        XCTAssertEqual(webView.receivedMessages, [.load("https://openai.com")])
    }

    func test_stopLoading_sendsCorrectMessage() {
        let (sut, webView, _, _) = makeSUT()

        sut.stopLoading()

        XCTAssertEqual(webView.receivedMessages, [.stopLoading])
    }

    func test_didTapBackButton_requestToGoBackToPreviousPage() {
        let (sut, webView, _, _) = makeSUT()

        sut.didTapBackButton()

        XCTAssertEqual(webView.receivedMessages, [.goBack])
    }

    func test_didTapForwardButton_requestNextPage() {
        let (sut, webView, _, _) = makeSUT()

        sut.didTapForwardButton()

        XCTAssertEqual(webView.receivedMessages, [.goForward])
    }

    func test_canGoBack_deliversCorrectResult() {
        let (sut, webView, _, _) = makeSUT()
        webView.canGoBackMock = true

        _ = sut.canGoBack()

        XCTAssertTrue(webView.canGoBack)
    }

    func test_canGoForward_deliversCorrectResult() {
        let (sut, webView, _, _) = makeSUT()
        webView.canGoForwardMock = true

        _ = sut.canGoForward()

        XCTAssertTrue(webView.canGoForward)
    }

    func test_observeValueForKeyPath_whenKeyPathIsEmptyDontSendAnyMessage() {
        let (sut, _, _, delegate) = makeSUT()

        sut.observeValue(forKeyPath: nil, of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_observeValueForKeyPath_whenKeyPathIsNotValidDontSendAnyMessage() {
        let (sut, _, _, delegate) = makeSUT()

        sut.observeValue(forKeyPath: "any", of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewTitleChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!
        webView.mockTitle = "Some Title"

        sut.observeValue(forKeyPath: #keyPath(WKWebView.title), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didLoadPage])
    }

    func test_observeValueForKeyPath_doNotSendMessageWhenMissingURL() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = nil

        sut.observeValue(forKeyPath: #keyPath(WKWebView.title), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewCanGoBackChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!

        sut.observeValue(forKeyPath: #keyPath(WKWebView.canGoBack), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdateNavigationButtons])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewCanGoForwardChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!

        sut.observeValue(forKeyPath: #keyPath(WKWebView.canGoForward), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdateNavigationButtons])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenLoadingProgressUpdates() {
        let (sut, _, _, delegate) = makeSUT()

        sut.observeValue(forKeyPath: #keyPath(WKWebView.estimatedProgress), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdateLoadingProgress(0)])
    }

    func test_removeAllRules_removesAllRegisteredRules() {
        let contentController = WKUserContentControllerSpy()
        let configuration = WKWebViewConfigurationDummy()
        configuration.userContentController = contentController
        let webView = WebViewMock(frame: .zero, configuration: configuration)
        let ruleStore = WKContentRuleListStoreSpy()
        let sut = WebKitEngineWrapper(webView: webView, ruleStore: ruleStore)

        sut.removeAllRules()

        XCTAssertEqual(contentController.receivedMessages, [.removeAllContentRuleLists])
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: WebKitEngineWrapper,
        webView: WebViewMock,
        ruleStore: WKContentRuleListStoreSpy,
        delegate: WebViewProxyDelegateSpy)
    {
        let delegate = WebViewProxyDelegateSpy()
        let webView = WebViewMock()
        let ruleStore = WKContentRuleListStoreSpy()
        let sut = WebKitEngineWrapper(webView: webView, ruleStore: ruleStore)
        sut.delegate = delegate

        return (sut, webView, ruleStore, delegate)
    }

    private class WKWebViewConfigurationDummy: WKWebViewConfiguration {}    
}
