final public class ContentBlocking {
    private let webView: WebViewContract
    private let jsonLoader: (String) -> String?

    public init(webView: WebViewContract, jsonLoader: @escaping (String) -> String? = Helpers.loadJsonContent(filename:)) {
        self.webView = webView
        self.jsonLoader = jsonLoader
    }

    public func setupBasicProtection(whitelist: [String] = []) {
        let rules = ["CookiesAdvertisingRules", "CookiesAnalyticsRules", "CookiesSocialRules", "CryptominingRules", "FingerprintingRules"]
        registerRules(rules: rules, whitelist: whitelist)
    }

    public func setupStrictProtection(whitelist: [String] = []) {
        let rules = ["AdvertisingRules", "AnalyticsRules", "SocialRules", "CryptominingRules", "FingerprintingRules"]
        registerRules(rules: rules, whitelist: whitelist)
    }

    public func removeProtection() {
        webView.removeAllRules()
    }

    private func registerRules(rules: [String], whitelist: [String]) {
        for rule in rules {
            if let content = jsonLoader(rule) {
                webView.registerRule(name: rule, content: content, whitelist: whitelist)
            }
        }
    }
}
