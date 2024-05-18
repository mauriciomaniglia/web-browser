import Foundation

public protocol WebViewContract {
    func registerRule(name: String, content: String, whitelist: [String])    
    func removeAllRules()
    func load(_ url: URL)
    func didTapBackButton()
    func didTapForwardButton()
}
