import Foundation

public protocol WebEngineContract {
    func getCurrentPage() -> WebPage?
    func registerRule(name: String, content: String, safelist: [String])
    func removeAllRules()
    func load(_ url: URL)
    func reload()
    func stopLoading()
    func didTapBackButton()
    func didTapForwardButton()
    func retrieveBackList() -> [WebPage]
    func retrieveForwardList() -> [WebPage]
    func navigateToBackListPage(at index: Int)
    func navigateToForwardListPage(at index: Int)
}
