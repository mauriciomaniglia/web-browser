import Foundation

public protocol WebEngineContract {
    func registerRule(name: String, content: String, safelist: [String])    
    func removeAllRules()
    func load(_ url: URL)
    func reload()
    func stopLoading()
    func didTapBackButton()
    func didTapForwardButton()
}
