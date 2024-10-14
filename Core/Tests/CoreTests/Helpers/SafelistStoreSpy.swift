@testable import Core

class SafelistStoreSpy: SafelistAPI {
    enum Message: Equatable {
        case isRegisteredDomain(_ domain: String)
        case fetchRegisteredDomains
        case saveDomain(_ domain: String)
        case removeDomain(_ domain: String)
    }

    var receivedMessages = [Message]()
    var isOnSafelist = false

    func isRegisteredDomain(_ domain: String) -> Bool {
        receivedMessages.append(.isRegisteredDomain(domain))
        return isOnSafelist
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
