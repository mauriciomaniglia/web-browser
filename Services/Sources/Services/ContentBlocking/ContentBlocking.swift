public protocol ContentBlockingDelegate {
    func load(_ rule: String) -> String?
    func registerRule(name: String, content: String, safelist: [String])
    func removeAllRules()
}

final public class ContentBlocking {
    private let delegate: ContentBlockingDelegate

    public init(delegate: ContentBlockingDelegate) {
        self.delegate = delegate
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
        delegate.removeAllRules()
    }

    private func registerRules(rules: [String], safelist: [String]) {
        for rule in rules {
            if let content = delegate.load(rule) {
                delegate.registerRule(name: rule, content: content, safelist: safelist)
            }
        }
    }
}
