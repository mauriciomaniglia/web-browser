import XCTest
import WebKit
import web_browser

@MainActor
class WebKitEngineWrapperTests: XCTestCase {
    let navigation = WKNavigation()

    func test_init_doesNotSendAnyMessage() {
        let (_, _, _, delegate) = makeSUT()

        XCTAssertEqual(delegate.receivedMessages, [])
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
