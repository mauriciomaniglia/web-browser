import XCTest
import core_web_browser

class ContentBlockingTests: XCTestCase {

    func test_init_doesNotSendAnyMessages() {
        let (_, webView) = makeSUT()

        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_setupBasicProtection_applyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})

        sut.setupBasicProtection()

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("CookiesAdvertisingRules", "json content"),
            .applyRule("CookiesAdvertisingRules"),
            .registerRule("CookiesAnalyticsRules", "json content"),
            .applyRule("CookiesAnalyticsRules"),
            .registerRule("CookiesSocialRules", "json content"),
            .applyRule("CookiesSocialRules"),
            .registerRule("CryptominingRules", "json content"),
            .applyRule("CryptominingRules"),
            .registerRule("FingerprintingRules", "json content"),
            .applyRule("FingerprintingRules")
        ])
    }

    func test_setupBasicProtection_whenWhitelistAreAvailableApplyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        let whitelist = ["www.apple.com", "www.google.com"]

        sut.setupBasicProtection(whitelist: whitelist)

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("CookiesAdvertisingRules", "json content", whitelist),
            .applyRule("CookiesAdvertisingRules"),
            .registerRule("CookiesAnalyticsRules", "json content", whitelist),
            .applyRule("CookiesAnalyticsRules"),
            .registerRule("CookiesSocialRules", "json content", whitelist),
            .applyRule("CookiesSocialRules"),
            .registerRule("CryptominingRules", "json content", whitelist),
            .applyRule("CryptominingRules"),
            .registerRule("FingerprintingRules", "json content", whitelist),
            .applyRule("FingerprintingRules")
        ])
    }

    func test_setupStrictProtection_applyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})

        sut.setupStrictProtection()

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("AdvertisingRules", "json content"),
            .applyRule("AdvertisingRules"),
            .registerRule("AnalyticsRules", "json content"),
            .applyRule("AnalyticsRules"),
            .registerRule("SocialRules", "json content"),
            .applyRule("SocialRules"),
            .registerRule("CryptominingRules", "json content"),
            .applyRule("CryptominingRules"),
            .registerRule("FingerprintingRules", "json content"),
            .applyRule("FingerprintingRules")
        ])
    }

    func test_setupStrictProtection_whenWhitelistAreAvailableApplyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        let whitelist = ["www.apple.com", "www.google.com"]

        sut.setupStrictProtection(whitelist: whitelist)

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("AdvertisingRules", "json content", whitelist),
            .applyRule("AdvertisingRules"),
            .registerRule("AnalyticsRules", "json content", whitelist),
            .applyRule("AnalyticsRules"),
            .registerRule("SocialRules", "json content", whitelist),
            .applyRule("SocialRules"),
            .registerRule("CryptominingRules", "json content", whitelist),
            .applyRule("CryptominingRules"),
            .registerRule("FingerprintingRules", "json content", whitelist),
            .applyRule("FingerprintingRules")
        ])
    }

    func test_removeProtection_removeAllRules() {
        let (sut, webView) = makeSUT()

        sut.removeProtection()

        XCTAssertEqual(webView.receivedMessages, [.removeAllRules])
    }


    // MARK: - Helpers

    private func makeSUT() -> (sut: ContentBlocking, webView: WebViewSpy) {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView)

        return (sut, webView)
    }
}
