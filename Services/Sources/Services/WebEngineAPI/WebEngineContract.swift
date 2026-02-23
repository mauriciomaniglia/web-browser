import Foundation

@MainActor
public protocol WebEngineContract {
    var sessionData: Data? { get set }

    func getCurrentPage() -> WebPageModel?
    func registerRule(name: String, content: String, safelist: [String])
    func removeAllRules()
    func load(_ url: URL)
    func reload()
    func stopLoading()
    func didTapBackButton()
    func didTapForwardButton()
    func retrieveBackList() -> [WebPageModel]
    func retrieveForwardList() -> [WebPageModel]
    func navigateToBackListPage(at index: Int)
    func navigateToForwardListPage(at index: Int)
    func takeSnapshot<T>() async -> T?
}

@MainActor
public protocol WebEngineDelegate: AnyObject {
    func didLoad(page: WebPageModel)
    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool)
    func didUpdateLoadingProgress(_ progress: Double)
}

public struct WebPageModel: Equatable {
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
