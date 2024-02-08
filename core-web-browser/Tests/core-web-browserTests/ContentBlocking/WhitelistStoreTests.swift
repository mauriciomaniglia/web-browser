import XCTest
import core_web_browser

class WhitelistStoreTests: XCTestCase {
    override func tearDown() {
        clearWhitelist()
    }

    func test_isRegisteredDomain_whenListIsEmptyReturnsFalse() {
        XCTAssertFalse(WhitelistStore.isRegisteredDomain("www.apple.com"))
    }

    func test_fetchRegisteredDomains_whenThereIsNoRegisteredDomainReturnsEmpty() {
        XCTAssertTrue(WhitelistStore.fetchRegisteredDomains().isEmpty)
    }

    func test_fetchRegisteredDomains_whenThereAreRegisteredDomainReturnsAllDomains() {
        WhitelistStore.saveDomain("www.apple.com")
        WhitelistStore.saveDomain("www.google.com")

        XCTAssertEqual(WhitelistStore.fetchRegisteredDomains(), ["www.apple.com", "www.google.com"])
    }

    func test_saveDomain_whenListIsEmptySavesTheNewDomain() {
        XCTAssertFalse(WhitelistStore.isRegisteredDomain("www.apple.com"))

        WhitelistStore.saveDomain("www.apple.com")

        XCTAssertTrue(WhitelistStore.isRegisteredDomain("www.apple.com"))
    }

    func test_saveDomain_whenListIsNotEmptySavesTheNewDomain() {
        WhitelistStore.saveDomain("www.apple.com")
        WhitelistStore.saveDomain("www.google.com")

        XCTAssertTrue(WhitelistStore.isRegisteredDomain("www.apple.com"))
        XCTAssertTrue(WhitelistStore.isRegisteredDomain("www.google.com"))
    }

    func test_removeDomain_whenDomainIsRegisteredRemoveFromTheList() {
        WhitelistStore.saveDomain("www.apple.com")

        WhitelistStore.removeDomain("www.apple.com")

        XCTAssertFalse(WhitelistStore.isRegisteredDomain("www.apple.com"))
    }

    func test_removeDomain_whenTheSameDomainIsRegisteredMoreThanOnceRemoveFromTheList() {
        WhitelistStore.saveDomain("www.apple.com")
        WhitelistStore.saveDomain("www.apple.com")
        WhitelistStore.saveDomain("www.apple.com")

        WhitelistStore.removeDomain("www.apple.com")

        XCTAssertFalse(WhitelistStore.isRegisteredDomain("www.apple.com"))
    }

    func test_removeDomain_whenListContainsOtherDomainsRemoveTheCorrectDomain() {
        WhitelistStore.saveDomain("www.apple.com")
        WhitelistStore.saveDomain("www.google.com")
        WhitelistStore.saveDomain("www.youtube.com")

        WhitelistStore.removeDomain("www.apple.com")

        XCTAssertFalse(WhitelistStore.isRegisteredDomain("www.apple.com"))
        XCTAssertTrue(WhitelistStore.isRegisteredDomain("www.google.com"))
        XCTAssertTrue(WhitelistStore.isRegisteredDomain("www.youtube.com"))
    }

    // MARK: - Helpers

    private func clearWhitelist() {
        UserDefaults.standard.set([], forKey: "Whitelist")
    }
}
