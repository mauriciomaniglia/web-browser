import Foundation

public class WhitelistStore {
    public static func isRegisteredDomain(_ domain: String) -> Bool {
        let whitelist = fetchRegisteredDomains()

        return whitelist.contains(domain)
    }

    public static func fetchRegisteredDomains() -> [String] {
        UserDefaults.standard.stringArray(forKey: "Whitelist") ?? []
    }

    public static func saveDomain(_ domain: String) {
        var whitelist = fetchRegisteredDomains()

        if !whitelist.contains(domain) {
            whitelist.append(domain)
            registerDomains(whitelist)
        }
    }

    public static func removeDomain(_ domain: String) {
        var whitelist = fetchRegisteredDomains()

        if let index = whitelist.firstIndex(of: domain) {
            whitelist.remove(at: index)
            registerDomains(whitelist)
        }
    }

    private static func registerDomains(_ domains: [String]) {
        UserDefaults.standard.set(domains, forKey: "Whitelist")
    }
}
