import Foundation
import Services

class WebViewSpy: WebEngineContract {
    enum Message: Equatable {
        case getCurrentPage
        case registerRule(_ name: String, _ content: String, _ safelist: [String] = [])
        case removeAllRules
        case load(url: URL)
        case reload
        case stopLoading
        case didTapBackButton
        case didTapForwardButton
        case retrieveBackList
        case retrieveForwardList
        case navigateToBackListPage
        case navigateToForwardListPage
        case takeSnapshot
    }

    var receivedMessages = [Message]()

    var mockBackList = [WebPageModel]()
    var mockFowardList = [WebPageModel]()

    var sessionData: Data?

    func getCurrentPage() -> WebPageModel? {
        receivedMessages.append(.getCurrentPage)
        return nil
    }

    func registerRule(name: String, content: String, safelist: [String] = []) {
        receivedMessages.append(.registerRule(name, content, safelist))
    }

    func removeAllRules() {
        receivedMessages.append(.removeAllRules)
    }

    func load(_ url: URL) {
        receivedMessages.append(.load(url: url))
    }

    func reload() {
        receivedMessages.append(.reload)
    }

    func stopLoading() {
        receivedMessages.append(.stopLoading)
    }

    func didTapBackButton() {
        receivedMessages.append(.didTapBackButton)
    }

    func didTapForwardButton() {
        receivedMessages.append(.didTapForwardButton)
    }

    func retrieveBackList() -> [WebPageModel] {
        receivedMessages.append(.retrieveBackList)
        return mockBackList
    }

    func retrieveForwardList() -> [WebPageModel] {
        receivedMessages.append(.retrieveForwardList)
        return mockFowardList
    }

    func navigateToBackListPage(at index: Int) {
        receivedMessages.append(.navigateToBackListPage)
    }

    func navigateToForwardListPage(at index: Int) {
        receivedMessages.append(.navigateToForwardListPage)
    }

    func takeSnapshot<T>(completionHandler: @escaping (T?) -> Void) {
        receivedMessages.append(.takeSnapshot)
    }
}
