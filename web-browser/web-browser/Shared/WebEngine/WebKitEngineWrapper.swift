import WebKit
import Services

@MainActor
public final class WebKitEngineWrapper: NSObject, WebEngineContract {
    private var observations: [NSKeyValueObservation] = []

    public weak var delegate: WebEngineDelegate?
    public let webView: WKWebView
    let ruleStore: WKContentRuleListStore

    public var sessionData: Data? {
        get {
            webView.interactionState as? Data
        }

        set {
            webView.interactionState = newValue
        }
    }

    public init(webView: WKWebView, ruleStore: WKContentRuleListStore) {
        self.webView = webView
        self.ruleStore = ruleStore
        super.init()
        registerObserversForWebView()
    }

    public override init() {
        self.webView = WKWebView()
        self.ruleStore = WKContentRuleListStore.default()
        super.init()
        registerObserversForWebView()
    }

    public func getCurrentPage() -> WebPageModel? {
        guard let url = webView.url else { return nil }
        return WebPageModel(title: webView.title, url: url, date: Date())
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

    public func retrieveBackList() -> [WebPageModel] {
        webView.backForwardList.backList.map {
            WebPageModel(title: $0.title, url: $0.url, date: Date())
        }
    }

    public func retrieveForwardList() -> [WebPageModel] {
        webView.backForwardList.forwardList.map {
            WebPageModel(title: $0.title, url: $0.url, date: Date())
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

    public func takeSnapshot<T>() async -> T? {
        await withCheckedContinuation { (continuation: CheckedContinuation<T?, Never>) in
            webView.takeSnapshot(with: nil) { image, _ in
                continuation.resume(returning: image as? T)
            }
        }
    }

    // MARK: Private methods

    private func registerObserversForWebView() {
        observations.append(webView.observe(\.url, options: [.new]) { [weak self] _, _ in
            Task { @MainActor in
                self?.updateNavigationButtons()
            }
        })

        observations.append(webView.observe(\.canGoBack, options: [.new]) { [weak self] _, _ in
            Task { @MainActor in self?.updateNavigationButtons() }
        })

        observations.append(webView.observe(\.canGoForward, options: [.new]) { [weak self] _, _ in
            Task { @MainActor in self?.updateNavigationButtons() }
        })

        observations.append(webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            Task { @MainActor in
                self?.delegate?.didUpdateLoadingProgress(webView.estimatedProgress)
            }
        })

        observations.append(webView.observe(\.title, options: [.new]) { [weak self] webView, _ in
            Task { @MainActor in
                guard let self = self,
                      let url = webView.url,
                      let title = webView.title, !title.isEmpty else { return }

                let webPage = WebPageModel(title: title, url: url, date: Date())
                self.delegate?.didLoad(page: webPage)
            }
        })
    }

    private func updateNavigationButtons() {
        delegate?.didUpdateNavigationButtons(
            canGoBack: webView.canGoBack,
            canGoForward: webView.canGoForward
        )
    }

    private func applyRule(name: String) {
        ruleStore.lookUpContentRuleList(forIdentifier: name, completionHandler: { [webView] ruleList, _ in
            guard let ruleList = ruleList else { return }

            webView.configuration.userContentController.add(ruleList)
        })
    }

    private static func safelistAsJSON(_ safelist: [String]) -> String {
        let list = "'*" + safelist.joined(separator: "','*") + "'"
        return ", {'action': { 'type': 'ignore-previous-rules' }, 'trigger': { 'url-filter': '.*', 'if-domain': [\(list)] }}".replacingOccurrences(of: "'", with: "\"")
    }
}

