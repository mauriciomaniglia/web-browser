import WebKit

public final class WebKitEngineWrapper: NSObject, WebEngineContract {
    public var delegate: WebEngineDelegate?
    public let webView: WKWebView
    let ruleStore: WKContentRuleListStore

    public init(webView: WKWebView = WKWebView(), ruleStore: WKContentRuleListStore = WKContentRuleListStore.default()) {
        self.webView = webView
        self.ruleStore = ruleStore
        super.init()
        registerObserversForWebView()
    }

    public func registerRule(name: String, content: String, safelist: [String] = []) {
        ruleStore.lookUpContentRuleList(forIdentifier: name, completionHandler: { [ruleStore] ruleList, _ in
            if ruleList != nil { return }

            var modifiedContent = content

            if safelist.count > 0, let range = content.range(of: "]", options: String.CompareOptions.backwards) {
                modifiedContent = modifiedContent.replacingCharacters(in: range, with: WebKitEngineWrapper.safelistAsJSON(safelist)  + "]")
            }

            ruleStore.compileContentRuleList(forIdentifier: name, encodedContentRuleList: modifiedContent, completionHandler: {_, _ in
                self.applyRule(name: name)
            })
        })
    }

    public func removeAllRules() {
        self.webView.configuration.userContentController.removeAllContentRuleLists()
    }

    public func load(_ url: URL) {
        webView.load(URLRequest(url: url))
    }

    public func reload() {
        webView.reload()
    }

    public func stopLoading() {
        webView.stopLoading()
    }

    public func didTapBackButton() {
        webView.goBack()
    }

    public func didTapForwardButton() {
        webView.goForward()
    }

    public func canGoBack() -> Bool {
        webView.canGoBack
    }

    public func canGoForward() -> Bool {
        webView.canGoForward
    }

    public func retrieveBackList() -> [WebPage] {
        webView.backForwardList.backList.map {
            WebPage(title: $0.title, url: $0.url.absoluteString)
        }
    }

    public func retrieveForwardList() -> [WebPage] {
        webView.backForwardList.forwardList.map {
            WebPage(title: $0.title, url: $0.url.absoluteString)
        }
    }

    public func navigateToBackListPage(at index: Int) {
        let bfList = webView.backForwardList
        let items = bfList.forwardList.reversed() + [bfList.currentItem].compactMap({ $0 }) + bfList.backList.reversed()

        webView.go(to: items[index+1])
    }

    public func navigateToForwardListPage(at index: Int) {
        let bfList = webView.backForwardList
        let items = bfList.backList + [bfList.currentItem].compactMap({ $0 }) + bfList.forwardList

        webView.go(to: items[index+1])
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }

        switch keyPath {
        case #keyPath(WKWebView.url), #keyPath(WKWebView.canGoBack), #keyPath(WKWebView.canGoForward):
            if let url = webView.url {
                delegate?.didLoadPage(url: url, canGoBack: webView.canGoBack, canGoForward: webView.canGoForward)
            }
        case #keyPath(WKWebView.estimatedProgress):
            delegate?.didUpdateLoadingProgress(webView.estimatedProgress)
        default:
            break
        }
    }

    // MARK: Private methods

    private func applyRule(name: String) {
        ruleStore.lookUpContentRuleList(forIdentifier: name, completionHandler: { [webView] ruleList, _ in
            guard let ruleList = ruleList else { return }

            webView.configuration.userContentController.add(ruleList)
        })
    }

    private func registerObserversForWebView() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }

    private static func safelistAsJSON(_ safelist: [String]) -> String {
        let list = "'*" + safelist.joined(separator: "','*") + "'"
        return ", {'action': { 'type': 'ignore-previous-rules' }, 'trigger': { 'url-filter': '.*', 'if-domain': [\(list)] }}".replacingOccurrences(of: "'", with: "\"")
    }
}

