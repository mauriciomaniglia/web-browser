import Foundation

public protocol WebEngineContract {
    func registerRule(name: String, content: String, whitelist: [String])    
    func removeAllRules()
    func load(_ url: URL)
    func stopLoading()
    func didTapBackButton()
    func didTapForwardButton()
}
