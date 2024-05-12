import Foundation

public protocol WhitelistAPI {
    func isRegisteredDomain(_ domain: String) -> Bool
    func fetchRegisteredDomains() -> [String]
    func saveDomain(_ domain: String)    
    func removeDomain(_ domain: String)
}

public class WhitelistStore: WhitelistAPI {
    public func isRegisteredDomain(_ domain: String) -> Bool {
        let whitelist = fetchRegisteredDomains()

        return whitelist.contains(domain)
    }

    public func fetchRegisteredDomains() -> [String] {
        UserDefaults.standard.stringArray(forKey: "Whitelist") ?? []
    }

    public func saveDomain(_ domain: String) {
        var whitelist = fetchRegisteredDomains()

        if !whitelist.contains(domain) {
            whitelist.append(domain)
            registerDomains(whitelist)
        }
    }

    public func removeDomain(_ domain: String) {
        var whitelist = fetchRegisteredDomains()

        if let index = whitelist.firstIndex(of: domain) {
            whitelist.remove(at: index)
            registerDomains(whitelist)
        }
    }

    private func registerDomains(_ domains: [String]) {
        UserDefaults.standard.set(domains, forKey: "Whitelist")
    }
}
