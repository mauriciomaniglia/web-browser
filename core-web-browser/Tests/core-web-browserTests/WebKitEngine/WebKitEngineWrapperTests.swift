import XCTest
import WebKit
import core_web_browser

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

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewURLChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!

        sut.observeValue(forKeyPath: #keyPath(WKWebView.url), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didLoadPage])
    }

    func test_observeValueForKeyPath_doNotSendMessageWhenMissingURL() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = nil

        sut.observeValue(forKeyPath: #keyPath(WKWebView.url), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewCanGoBackChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!

        sut.observeValue(forKeyPath: #keyPath(WKWebView.canGoBack), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didLoadPage])
    }

    func test_observeValueForKeyPath_sendsCorrectMessageWhenWebViewCanGoForwardChange() {
        let (sut, webView, _, delegate) = makeSUT()
        webView.mockURL = URL(string: "http://some-url.com")!

        sut.observeValue(forKeyPath: #keyPath(WKWebView.canGoForward), of: nil, change: nil, context: nil)

        XCTAssertEqual(delegate.receivedMessages, [.didLoadPage])
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
        let webView = WebViewSpy(frame: .zero, configuration: configuration)
        let ruleStore = WKContentRuleListStoreSpy()
        let sut = WebKitEngineWrapper(webView: webView, ruleStore: ruleStore)

        sut.removeAllRules()

        XCTAssertEqual(contentController.receivedMessages, [.removeAllContentRuleLists])
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: WebKitEngineWrapper,
        webView: WebViewSpy,
        ruleStore: WKContentRuleListStoreSpy,
        delegate: WebViewProxyDelegateSpy)
    {
        let delegate = WebViewProxyDelegateSpy()
        let webView = WebViewSpy()
        let ruleStore = WKContentRuleListStoreSpy()
        let sut = WebKitEngineWrapper(webView: webView, ruleStore: ruleStore)
        sut.delegate = delegate

        return (sut, webView, ruleStore, delegate)
    }

    private class WKWebViewConfigurationDummy: WKWebViewConfiguration {}

    private class WKUserContentControllerSpy: WKUserContentController {
        enum Message {
            case add
            case removeAllContentRuleLists
        }

        var receivedMessages: [Message] = []

        override func add(_ contentRuleList: WKContentRuleList) {
            receivedMessages.append(.add)
        }

        override func removeAllContentRuleLists() {
            receivedMessages.append(.removeAllContentRuleLists)
        }
    }

    private class WebViewSpy: WKWebView {
        enum Message: Equatable {
            case load(_ requestDescription: String)
            case stopLoading
            case goBack
            case goForward
        }

        var receivedMessages = [Message]()
        var registeredObservers = [String]()
        var canGoBackMock = false
        var canGoForwardMock = false
        var mockURL: URL?

        override var url: URL? {
            mockURL
        }

        override func load(_ request: URLRequest) -> WKNavigation? {
            receivedMessages.append(.load(request.description))
            return super.load(request)
        }

        override func stopLoading() {
            receivedMessages.append(.stopLoading)
            return super.stopLoading()
        }

        override func goBack() -> WKNavigation? {
            receivedMessages.append(.goBack)
            return super.goBack()
        }

        override func goForward() -> WKNavigation? {
            receivedMessages.append(.goForward)
            return super.goForward()
        }

        override var canGoBack: Bool {
            return canGoBackMock
        }

        override var canGoForward: Bool {
            return canGoForwardMock
        }

        override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
            registeredObservers.append(keyPath)
        }
    }

    private class WKContentRuleListStoreSpy: WKContentRuleListStore {
        enum Message: Equatable {
            case lookUpContentRuleList(identifier: String)
            case compileContentRuleList(identifier: String, encodedContentRuleList: String = "")
        }

        var receivedMessages = [Message]()
        var lookUpContentRuleListCompletion: ((WKContentRuleList?, Error?) -> Void)?

        override func lookUpContentRuleList(forIdentifier identifier: String!, completionHandler: ((WKContentRuleList?, Error?) -> Void)!) {
            lookUpContentRuleListCompletion = completionHandler
            receivedMessages.append(.lookUpContentRuleList(identifier: identifier))
        }

        override func compileContentRuleList(forIdentifier identifier: String!, encodedContentRuleList: String!, completionHandler: ((WKContentRuleList?, Error?) -> Void)!) {
            receivedMessages.append(.compileContentRuleList(identifier: identifier, encodedContentRuleList: encodedContentRuleList))
            super.compileContentRuleList(forIdentifier: identifier, encodedContentRuleList: encodedContentRuleList, completionHandler: completionHandler)
        }

        func simulateLookUpContentRuleListWithRegisteredItem() {
            lookUpContentRuleListCompletion?(WKContentRuleList(), nil)
        }

        func simulateLookUpContentRuleListWithUnregisteredItem() {
            lookUpContentRuleListCompletion?(nil, nil)
        }
    }

    private class WebViewProxyDelegateSpy: WebEngineDelegate {
        enum Message: Equatable {
            case didLoadPage
            case didUpdateLoadingProgress(_: Double)
        }

        var receivedMessages = [Message]()

        func didLoad(page: core_web_browser.WebPage) {

        }

        func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
            
        }

        func didLoad(page: WebPage, canGoBack: Bool, canGoForward: Bool) {
            receivedMessages.append(.didLoadPage)
        }

        func didUpdateLoadingProgress(_ progress: Double) {
            receivedMessages.append(.didUpdateLoadingProgress(progress))
        }
    }
}
