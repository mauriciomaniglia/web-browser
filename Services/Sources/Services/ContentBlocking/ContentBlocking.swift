@MainActor
final public class ContentBlocking<T: WebEngineContract> {
    private let webView: T
    private let jsonLoader: (String) -> String?

    public init(webView: T, jsonLoader: @escaping (String) -> String?) {
        self.webView = webView
        self.jsonLoader = jsonLoader
    }

    public func setupBasicProtection(safelist: [String] = []) {
        let rules = ["CookiesAdvertisingRules", "CookiesAnalyticsRules", "CookiesSocialRules", "CryptominingRules", "FingerprintingRules"]
        registerRules(rules: rules, safelist: safelist)
    }

    public func setupStrictProtection(safelist: [String] = []) {
        let rules = ["AdvertisingRules", "AnalyticsRules", "SocialRules", "CryptominingRules", "FingerprintingRules"]
        registerRules(rules: rules, safelist: safelist)
    }

    public func removeProtection() {
        webView.removeAllRules()
    }

    private func registerRules(rules: [String], safelist: [String]) {
        for rule in rules {
            if let content = jsonLoader(rule) {
                webView.registerRule(name: rule, content: content, safelist: safelist)
            }
        }
    }
}
