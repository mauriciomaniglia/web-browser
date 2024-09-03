import WebKit

class WebViewMock: WKWebView {
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
    var mockTitle: String?

    override var url: URL? {
        mockURL
    }

    override var title: String? {
        mockTitle
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
