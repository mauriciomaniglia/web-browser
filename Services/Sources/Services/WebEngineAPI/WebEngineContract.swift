import Foundation

public protocol WebEngineContract {
    var sessionData: Data? { get set }

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
    func takeSnapshot<T>(completionHandler: @escaping (T?) -> Void)
}

public protocol WebEngineDelegate: AnyObject {
    func didLoad(page: WebPage)
    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool)
    func didUpdateLoadingProgress(_ progress: Double)
}

public struct WebPage: Equatable {
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
