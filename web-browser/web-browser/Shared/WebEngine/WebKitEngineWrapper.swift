import WebKit
import Services

public final class WebKitEngineWrapper: NSObject, WebEngineContract {
    public weak var delegate: WebEngineDelegate?
    public let webView: WKWebView
    let ruleStore: WKContentRuleListStore

    public init(webView: WKWebView = WKWebView(), ruleStore: WKContentRuleListStore = WKContentRuleListStore.default()) {
        self.webView = webView
        self.ruleStore = ruleStore
        super.init()
        registerObserversForWebView()
    }

    public func getCurrentPage() -> WebPage? {
        guard let url = webView.url else { return nil }
        return WebPage(title: webView.title, url: url, date: Date())
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
            WebPage(title: $0.title, url: $0.url, date: Date())
        }
    }

    public func retrieveForwardList() -> [WebPage] {
        webView.backForwardList.forwardList.map {
            WebPage(title: $0.title, url: $0.url, date: Date())
        }
    }

    public func navigateToBackListPage(at index: Int) {
        let backList: [WKBackForwardListItem] = webView.backForwardList.backList.reversed()
        let forwardList: [WKBackForwardListItem] = webView.backForwardList.forwardList.reversed()
        let items =  backList + forwardList

        webView.go(to: items[index])
    }

    public func navigateToForwardListPage(at index: Int) {
        let items = webView.backForwardList.forwardList + webView.backForwardList.backList

        webView.go(to: items[index])
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }

        switch keyPath {
        case #keyPath(WKWebView.url), #keyPath(WKWebView.canGoBack), #keyPath(WKWebView.canGoForward):
            delegate?.didUpdateNavigationButtons(canGoBack: webView.canGoBack, canGoForward: webView.canGoForward)
        case #keyPath(WKWebView.estimatedProgress):
            delegate?.didUpdateLoadingProgress(webView.estimatedProgress)
        case #keyPath(WKWebView.title):
            if let url = webView.url, let title = webView.title, !title.isEmpty {
                let webPage = WebPage(title: webView.title, url: url, date: Date())
                delegate?.didLoad(page: webPage)
            }
        default:
            break
        }
    }

    public func takeSnapshot<T>(completionHandler: @escaping (T?) -> Void) {
        let config = WKSnapshotConfiguration()
        webView.takeSnapshot(with: config) { image, error in
            completionHandler(image as? T)
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
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), context: nil)
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

