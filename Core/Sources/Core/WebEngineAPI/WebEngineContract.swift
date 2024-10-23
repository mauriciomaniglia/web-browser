import Foundation

public struct WebPage {
    public let id: UUID
    public let title: String?
    public let url: URL
    public let date: Date

    public init(id: UUID = UUID(), title: String?, url: URL, date: Date) {
        self.id = id
        self.title = title
        self.url = url
        self.date = date
    }
}

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
