import XCTest
import Services

class ContentBlockingTests: XCTestCase {

    func test_init_doesNotSendAnyMessages() {
        let (_, webView) = makeSUT()

        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_setupBasicProtection_applyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")

        sut.setupBasicProtection()

        XCTAssertEqual(delegate.receivedMessages, [
            .load("CookiesAdvertisingRules"),
            .registerRule(name: "CookiesAdvertisingRules", content: "json content", safelist: []),
            .load("CookiesAnalyticsRules"),
            .registerRule(name: "CookiesAnalyticsRules", content: "json content", safelist: []),
            .load("CookiesSocialRules"),
            .registerRule(name: "CookiesSocialRules", content: "json content", safelist: []),
            .load("CryptominingRules"),
            .registerRule(name: "CryptominingRules", content: "json content", safelist: []),
            .load("FingerprintingRules"),
            .registerRule(name: "FingerprintingRules", content: "json content", safelist: [])
        ])
    }

    func test_setupBasicProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupBasicProtection(safelist: safelist)

        XCTAssertEqual(delegate.receivedMessages, [
            .load("CookiesAdvertisingRules"),
            .registerRule(name: "CookiesAdvertisingRules", content: "json content", safelist: safelist),
            .load("CookiesAnalyticsRules"),
            .registerRule(name: "CookiesAnalyticsRules", content: "json content", safelist: safelist),
            .load("CookiesSocialRules"),
            .registerRule(name: "CookiesSocialRules", content: "json content", safelist: safelist),
            .load("CryptominingRules"),
            .registerRule(name: "CryptominingRules", content: "json content", safelist: safelist),
            .load("FingerprintingRules"),
            .registerRule(name: "FingerprintingRules", content: "json content", safelist: safelist)
        ])
    }

    func test_setupStrictProtection_applyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")

        sut.setupStrictProtection()

        XCTAssertEqual(delegate.receivedMessages, [
            .load("AdvertisingRules"),
            .registerRule(name: "AdvertisingRules", content: "json content", safelist: []),
            .load("AnalyticsRules"),
            .registerRule(name: "AnalyticsRules", content: "json content", safelist: []),
            .load("SocialRules"),
            .registerRule(name: "SocialRules", content: "json content", safelist: []),
            .load("CryptominingRules"),
            .registerRule(name: "CryptominingRules", content: "json content", safelist: []),
            .load("FingerprintingRules"),
            .registerRule(name: "FingerprintingRules", content: "json content", safelist: [])
        ])
    }

    func test_setupStrictProtection_whenSafelistAreAvailableApplyCorrectRules() {
        let (sut, delegate) = makeSUT(content: "json content")
        let safelist = ["www.apple.com", "www.google.com"]

        sut.setupStrictProtection(safelist: safelist)

        XCTAssertEqual(delegate.receivedMessages, [
            .load("AdvertisingRules"),
            .registerRule(name: "AdvertisingRules", content: "json content", safelist: safelist),
            .load("AnalyticsRules"),
            .registerRule(name: "AnalyticsRules", content: "json content", safelist: safelist),
            .load("SocialRules"),
            .registerRule(name: "SocialRules", content: "json content", safelist: safelist),
            .load("CryptominingRules"),
            .registerRule(name: "CryptominingRules", content: "json content", safelist: safelist),
            .load("FingerprintingRules"),
            .registerRule(name: "FingerprintingRules", content: "json content", safelist: safelist)
        ])
    }

    func test_removeProtection_removeAllRules() {
        let (sut, delegate) = makeSUT()

        sut.removeProtection()

        XCTAssertEqual(delegate.receivedMessages, [.removeAllRules])
    }


    // MARK: - Helpers

    private func makeSUT(content: String? = nil) -> (sut: ContentBlocking, delegate: ContentBlockingDelegateSpy) {
        let delegate = ContentBlockingDelegateSpy()
        let sut = ContentBlocking(delegate: delegate)
        delegate.mockRule = content
        return (sut, delegate)
    }
}

private class ContentBlockingDelegateSpy: ContentBlockingDelegate {
    enum Message: Equatable {
        case load(_ rule: String)
        case registerRule(name: String, content: String, safelist: [String])
        case removeAllRules
    }

    var receivedMessages: [Message] = []
    var mockRule: String?

    func load(_ rule: String) -> String? {
        receivedMessages.append(.load(rule))
        return mockRule
    }
    
    func registerRule(name: String, content: String, safelist: [String]) {
        receivedMessages.append(.registerRule(name: name, content: content, safelist: safelist))
    }
    
    func removeAllRules() {
        receivedMessages.append(.removeAllRules)
    }
}
