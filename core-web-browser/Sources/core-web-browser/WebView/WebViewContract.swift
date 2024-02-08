import Foundation

public protocol WebViewContract {
    func registerRule(name: String, content: String, whitelist: [String])
    func applyRule(name: String)
    func removeAllRules()
    func load(_ url: URL)
    func didTapBackButton()
    func didTapForwardButton()
    func canGoBack() -> Bool
    func canGoForward() -> Bool
}
