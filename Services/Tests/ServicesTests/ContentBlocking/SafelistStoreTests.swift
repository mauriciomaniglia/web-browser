import Foundation
import Testing
@testable import Services

@MainActor
@Suite("SafelistStore")
struct SafelistStoreTests {

    @Test("isRegisteredDomain returns false when the list is empty")
    func isRegisteredDomain_whenListIsEmptyReturnsFalse() {
        Self.resetSafelist()
        let store = SafelistStore()

        #expect(store.isRegisteredDomain("www.apple.com") == false, "No domains should be registered initially")
    }

    @Test("fetchRegisteredDomains returns an empty array when no domains are registered")
    func fetchRegisteredDomains_whenThereIsNoRegisteredDomainReturnsEmpty() {
        Self.resetSafelist()
        let store = SafelistStore()

        #expect(store.fetchRegisteredDomains().isEmpty, "Should be empty when nothing has been saved")
    }

    @Test("fetchRegisteredDomains returns all registered domains in insertion order")
    func fetchRegisteredDomains_whenThereAreRegisteredDomainReturnsAllDomains() {
        Self.resetSafelist()
        let store = SafelistStore()
        store.saveDomain("www.apple.com")
        store.saveDomain("www.google.com")

        #expect(store.fetchRegisteredDomains() == ["www.apple.com", "www.google.com"], "Should return all saved domains")
    }

    @Test("saveDomain saves the new domain when the list is empty")
    func saveDomain_whenListIsEmptySavesTheNewDomain() {
        Self.resetSafelist()
        let store = SafelistStore()
        #expect(store.isRegisteredDomain("www.apple.com") == false, "Precondition: domain should not be registered")

        store.saveDomain("www.apple.com")

        #expect(store.isRegisteredDomain("www.apple.com"), "Domain should be registered after saving")
    }

    @Test("saveDomain appends new domains when the list is not empty")
    func saveDomain_whenListIsNotEmptySavesTheNewDomain() {
        Self.resetSafelist()
        let store = SafelistStore()
        store.saveDomain("www.apple.com")
        store.saveDomain("www.google.com")

        #expect(store.isRegisteredDomain("www.apple.com"), "Apple should be registered")
        #expect(store.isRegisteredDomain("www.google.com"), "Google should be registered")
    }

    @Test("removeDomain removes a registered domain from the list")
    func removeDomain_whenDomainIsRegisteredRemoveFromTheList() {
        Self.resetSafelist()
        let store = SafelistStore()
        store.saveDomain("www.apple.com")

        store.removeDomain("www.apple.com")

        #expect(store.isRegisteredDomain("www.apple.com") == false, "Domain should be removed")
    }

    @Test("removeDomain removes the domain even if it was saved multiple times")
    func removeDomain_whenTheSameDomainIsRegisteredMoreThanOnceRemoveFromTheList() {
        Self.resetSafelist()
        let store = SafelistStore()
        store.saveDomain("www.apple.com")
        store.saveDomain("www.apple.com")
        store.saveDomain("www.apple.com")

        store.removeDomain("www.apple.com")

        #expect(store.isRegisteredDomain("www.apple.com") == false, "Domain should be removed regardless of duplicates")
    }

    @Test("removeDomain removes only the specified domain and preserves others")
    func removeDomain_whenListContainsOtherDomainsRemoveTheCorrectDomain() {
        Self.resetSafelist()
        let store = SafelistStore()
        store.saveDomain("www.apple.com")
        store.saveDomain("www.google.com")
        store.saveDomain("www.youtube.com")

        store.removeDomain("www.apple.com")

        #expect(store.isRegisteredDomain("www.apple.com") == false, "Apple should be removed")
        #expect(store.isRegisteredDomain("www.google.com"), "Google should remain registered")
        #expect(store.isRegisteredDomain("www.youtube.com"), "YouTube should remain registered")
    }

    // MARK: - Helpers

    private static func resetSafelist() {
        UserDefaults.standard.set([], forKey: "Safelist")
    }
}
