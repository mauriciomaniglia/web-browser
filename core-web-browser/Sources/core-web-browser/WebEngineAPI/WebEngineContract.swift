import Foundation

public struct WebPage {
    public let title: String?
    public let url: URL
    public let date: Date

    public init(title: String?, url: URL, date: Date) {
        self.title = title
        self.url = url
        self.date = date
    }
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
    func navigateToBackListPage(at index: Int)
    func navigateToForwardListPage(at index: Int)
}
