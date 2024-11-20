import Foundation

public class SafelistStore: SafelistAPI {
    public init() {}

    public func isRegisteredDomain(_ domain: String) -> Bool {
        let safelist = fetchRegisteredDomains()

        return safelist.contains(domain)
    }

    public func fetchRegisteredDomains() -> [String] {
        UserDefaults.standard.stringArray(forKey: "Safelist") ?? []
    }

    public func saveDomain(_ domain: String) {
        var safelist = fetchRegisteredDomains()

        if !safelist.contains(domain) {
            safelist.append(domain)
            registerDomains(safelist)
        }
    }

    public func removeDomain(_ domain: String) {
        var safelist = fetchRegisteredDomains()

        if let index = safelist.firstIndex(of: domain) {
            safelist.remove(at: index)
            registerDomains(safelist)
        }
    }

    private func registerDomains(_ domains: [String]) {
        UserDefaults.standard.set(domains, forKey: "Safelist")
    }
}
