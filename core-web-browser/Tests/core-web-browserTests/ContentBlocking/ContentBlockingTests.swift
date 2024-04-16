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
            .registerRule("CookiesAnalyticsRules", "json content"),
            .registerRule("CookiesSocialRules", "json content"),
            .registerRule("CryptominingRules", "json content"),
            .registerRule("FingerprintingRules", "json content"),
        ])
    }

    func test_setupBasicProtection_whenWhitelistAreAvailableApplyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        let whitelist = ["www.apple.com", "www.google.com"]

        sut.setupBasicProtection(whitelist: whitelist)

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("CookiesAdvertisingRules", "json content", whitelist),
            .registerRule("CookiesAnalyticsRules", "json content", whitelist),
            .registerRule("CookiesSocialRules", "json content", whitelist),
            .registerRule("CryptominingRules", "json content", whitelist),
            .registerRule("FingerprintingRules", "json content", whitelist),
        ])
    }

    func test_setupStrictProtection_applyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})

        sut.setupStrictProtection()

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("AdvertisingRules", "json content"),
            .registerRule("AnalyticsRules", "json content"),
            .registerRule("SocialRules", "json content"),
            .registerRule("CryptominingRules", "json content"),
            .registerRule("FingerprintingRules", "json content"),
        ])
    }

    func test_setupStrictProtection_whenWhitelistAreAvailableApplyCorrectRules() {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        let whitelist = ["www.apple.com", "www.google.com"]

        sut.setupStrictProtection(whitelist: whitelist)

        XCTAssertEqual(webView.receivedMessages, [
            .registerRule("AdvertisingRules", "json content", whitelist),
            .registerRule("AnalyticsRules", "json content", whitelist),
            .registerRule("SocialRules", "json content", whitelist),
            .registerRule("CryptominingRules", "json content", whitelist),
            .registerRule("FingerprintingRules", "json content", whitelist),            
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
