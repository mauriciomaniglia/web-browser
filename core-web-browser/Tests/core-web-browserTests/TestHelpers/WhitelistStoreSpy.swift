@testable import core_web_browser

class WhitelistStoreSpy: WhitelistAPI {
    enum Message: Equatable {
        case isRegisteredDomain(_ domain: String)
        case fetchRegisteredDomains
        case saveDomain(_ domain: String)
        case removeDomain(_ domain: String)
    }

    var receivedMessages = [Message]()

    func isRegisteredDomain(_ domain: String) -> Bool {
        receivedMessages.append(.isRegisteredDomain(domain))
        return false
    }

    func fetchRegisteredDomains() -> [String] {
        receivedMessages.append(.fetchRegisteredDomains)
        return []
    }

    func saveDomain(_ domain: String) {
        receivedMessages.append(.saveDomain(domain))
    }

    func removeDomain(_ domain: String) {
        receivedMessages.append(.removeDomain(domain))
    }
}
