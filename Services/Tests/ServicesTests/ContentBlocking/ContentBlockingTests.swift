import XCTest
import Services

@MainActor
class ContentBlockingTests: XCTestCase {

    func test_init_doesNotSendAnyMessages() {
        let (_, webView) = makeSUT()

        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_setupBasicProtection_applyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")

        sut.setupBasicProtection()

        XCTAssertEqual(delegate.receivedMessages, [
            .registerRule("CookiesAdvertisingRules", "json content", []),
            .registerRule("CookiesAnalyticsRules", "json content", []),
            .registerRule("CookiesSocialRules", "json content", []),
            .registerRule("CryptominingRules", "json content", []),
            .registerRule("FingerprintingRules", "json content", [])
        ])
    }

    func test_setupBasicProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupBasicProtection(safelist: safelist)

        XCTAssertEqual(delegate.receivedMessages, [
            .registerRule("CookiesAdvertisingRules", "json content", safelist),
            .registerRule("CookiesAnalyticsRules", "json content", safelist),
            .registerRule("CookiesSocialRules", "json content", safelist),
            .registerRule("CryptominingRules", "json content", safelist),
            .registerRule("FingerprintingRules", "json content", safelist)
        ])
    }

    func test_setupStrictProtection_applyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")

        sut.setupStrictProtection()

        XCTAssertEqual(delegate.receivedMessages, [
            .registerRule("AdvertisingRules", "json content", []),
            .registerRule("AnalyticsRules", "json content", []),
            .registerRule("SocialRules", "json content", []),
            .registerRule("CryptominingRules", "json content", []),
            .registerRule("FingerprintingRules", "json content", [])
        ])
    }

    func test_setupStrictProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupStrictProtection(safelist: safelist)

        XCTAssertEqual(delegate.receivedMessages, [
            .registerRule("AdvertisingRules", "json content", safelist),
            .registerRule("AnalyticsRules", "json content", safelist),
            .registerRule("SocialRules", "json content", safelist),
            .registerRule("CryptominingRules", "json content", safelist),
            .registerRule("FingerprintingRules", "json content", safelist)
        ])
    }

    func test_removeProtection_removeAllRules() {
        let (sut, delegate) = makeSUT()

        sut.removeProtection()

        XCTAssertEqual(delegate.receivedMessages, [.removeAllRules])
    }


    // MARK: - Helpers

    private func makeSUT(content: String? = nil) -> (sut: ContentBlocking, webView: WebViewSpy) {
        let webView = WebViewSpy()
        let sut = ContentBlocking(webView: webView, jsonLoader: { _ in "json content"})
        return (sut, webView)
    }
}
