import Testing
import Services

@MainActor
@Suite
struct ContentBlockingTests {

    @Test("Initialization does not send any messages to the web view")
    func init_doesNotSendAnyMessages() {
        let (_, webView) = Self.makeSUT()

        #expect(webView.receivedMessages.isEmpty, "No messages should be sent on init")
    }

    @Test("Basic protection registers the expected cookie, crypto, and fingerprinting rules")
    func setupBasicProtection_applyCorrectRules() {
        let (sut, delegate) = Self.makeSUT(content: "json content")

        sut.setupBasicProtection()

        #expect(delegate.receivedMessages == [
            .registerRule("CookiesAdvertisingRules", "json content", []),
            .registerRule("CookiesAnalyticsRules", "json content", []),
            .registerRule("CookiesSocialRules", "json content", []),
            .registerRule("CryptominingRules", "json content", []),
            .registerRule("FingerprintingRules", "json content", [])
        ], "Should register the expected basic protection rules with empty safelist")
    }

    @Test("Basic protection with a safelist applies the same rules constrained by the safelist")
    func setupBasicProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = Self.makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupBasicProtection(safelist: safelist)

        #expect(delegate.receivedMessages == [
            .registerRule("CookiesAdvertisingRules", "json content", safelist),
            .registerRule("CookiesAnalyticsRules", "json content", safelist),
            .registerRule("CookiesSocialRules", "json content", safelist),
            .registerRule("CryptominingRules", "json content", safelist),
            .registerRule("FingerprintingRules", "json content", safelist)
        ], "Should register basic protection rules constrained by the provided safelist")
    }

    @Test("Strict protection registers the full set of blocking rules")
    func setupStrictProtection_applyCorrectRules() {
        let (sut, delegate) = Self.makeSUT(content: "json content")

        sut.setupStrictProtection()

        #expect(delegate.receivedMessages == [
            .registerRule("AdvertisingRules", "json content", []),
            .registerRule("AnalyticsRules", "json content", []),
            .registerRule("SocialRules", "json content", []),
            .registerRule("CryptominingRules", "json content", []),
            .registerRule("FingerprintingRules", "json content", [])
        ], "Should register strict protection rules with empty safelist")
    }

    @Test("Strict protection with a safelist applies the rules constrained by the safelist")
    func setupStrictProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = Self.makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupStrictProtection(safelist: safelist)

        #expect(delegate.receivedMessages == [
            .registerRule("AdvertisingRules", "json content", safelist),
            .registerRule("AnalyticsRules", "json content", safelist),
            .registerRule("SocialRules", "json content", safelist),
            .registerRule("CryptominingRules", "json content", safelist),
            .registerRule("FingerprintingRules", "json content", safelist)
        ], "Should register strict protection rules constrained by the provided safelist")
    }

    @Test("Removing protection clears all registered rules")
    func removeProtection_removeAllRules() {
        let (sut, delegate) = Self.makeSUT()

        sut.removeProtection()

        #expect(delegate.receivedMessages == [.removeAllRules], "Should remove all rules from the web view delegate")
    }

    // MARK: - Helpers

    private static func makeSUT(content: String? = nil) -> (sut: ContentBlocking<WebViewSpy>, webView: WebViewSpy) {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        return (sut, webView)
    }
}
