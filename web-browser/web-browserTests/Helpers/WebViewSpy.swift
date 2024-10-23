import Foundation
import Core

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
    }

    var receivedMessages = [Message]()

    func getCurrentPage() -> WebPage? {
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

    func retrieveBackList() -> [WebPage] {
        receivedMessages.append(.retrieveBackList)
        return []
    }

    func retrieveForwardList() -> [WebPage] {
        receivedMessages.append(.retrieveForwardList)
        return []
    }

    func navigateToBackListPage(at index: Int) {
        receivedMessages.append(.navigateToBackListPage)
    }

    func navigateToForwardListPage(at index: Int) {
        receivedMessages.append(.navigateToForwardListPage)
    }
}
