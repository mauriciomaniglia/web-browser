public protocol SafelistAPI {
    func isRegisteredDomain(_ domain: String) -> Bool
    func fetchRegisteredDomains() -> [String]
    func saveDomain(_ domain: String)
    func removeDomain(_ domain: String)
}
