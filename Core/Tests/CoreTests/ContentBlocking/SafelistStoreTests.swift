import XCTest
@testable import Core

class SafelistStoreTests: XCTestCase {
    override func tearDown() {
        clearSafelist()
    }

    func test_isRegisteredDomain_whenListIsEmptyReturnsFalse() {
        XCTAssertFalse(SafelistStore().isRegisteredDomain("www.apple.com"))
    }

    func test_fetchRegisteredDomains_whenThereIsNoRegisteredDomainReturnsEmpty() {
        XCTAssertTrue(SafelistStore().fetchRegisteredDomains().isEmpty)
    }

    func test_fetchRegisteredDomains_whenThereAreRegisteredDomainReturnsAllDomains() {
        SafelistStore().saveDomain("www.apple.com")
        SafelistStore().saveDomain("www.google.com")

        XCTAssertEqual(SafelistStore().fetchRegisteredDomains(), ["www.apple.com", "www.google.com"])
    }

    func test_saveDomain_whenListIsEmptySavesTheNewDomain() {
        XCTAssertFalse(SafelistStore().isRegisteredDomain("www.apple.com"))

        SafelistStore().saveDomain("www.apple.com")

        XCTAssertTrue(SafelistStore().isRegisteredDomain("www.apple.com"))
    }

    func test_saveDomain_whenListIsNotEmptySavesTheNewDomain() {
        SafelistStore().saveDomain("www.apple.com")
        SafelistStore().saveDomain("www.google.com")

        XCTAssertTrue(SafelistStore().isRegisteredDomain("www.apple.com"))
        XCTAssertTrue(SafelistStore().isRegisteredDomain("www.google.com"))
    }

    func test_removeDomain_whenDomainIsRegisteredRemoveFromTheList() {
        SafelistStore().saveDomain("www.apple.com")

        SafelistStore().removeDomain("www.apple.com")

        XCTAssertFalse(SafelistStore().isRegisteredDomain("www.apple.com"))
    }

    func test_removeDomain_whenTheSameDomainIsRegisteredMoreThanOnceRemoveFromTheList() {
        SafelistStore().saveDomain("www.apple.com")
        SafelistStore().saveDomain("www.apple.com")
        SafelistStore().saveDomain("www.apple.com")

        SafelistStore().removeDomain("www.apple.com")

        XCTAssertFalse(SafelistStore().isRegisteredDomain("www.apple.com"))
    }

    func test_removeDomain_whenListContainsOtherDomainsRemoveTheCorrectDomain() {
        SafelistStore().saveDomain("www.apple.com")
        SafelistStore().saveDomain("www.google.com")
        SafelistStore().saveDomain("www.youtube.com")

        SafelistStore().removeDomain("www.apple.com")

        XCTAssertFalse(SafelistStore().isRegisteredDomain("www.apple.com"))
        XCTAssertTrue(SafelistStore().isRegisteredDomain("www.google.com"))
        XCTAssertTrue(SafelistStore().isRegisteredDomain("www.youtube.com"))
    }

    // MARK: - Helpers

    private func clearSafelist() {
        UserDefaults.standard.set([], forKey: "Safelist")
    }
}
