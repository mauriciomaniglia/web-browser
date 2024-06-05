import Foundation

public struct WebPage {
    let title: String
    let url: String
}

public protocol WebEngineContract {
    func registerRule(name: String, content: String, safelist: [String])    
    func removeAllRules()
    func load(_ url: URL)
    func reload()
    func stopLoading()
    func didTapBackButton()
    func didTapForwardButton()
    func retrieveBackList() -> [WebPage]
    func retrieveForwardList() -> [WebPage]
}
