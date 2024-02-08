import Foundation
import core_web_browser

class WebViewSpy: WebViewContract {
    enum Message: Equatable {
        case registerRule(_ name: String, _ content: String, _ whitelist: [String] = [])
        case applyRule(_ name: String)
        case removeAllRules
        case load(url: URL)
        case didTapBackButton
        case didTapForwardButton
        case canGoBack
        case canGoForward
    }

    var receivedMessages = [Message]()

    func registerRule(name: String, content: String, whitelist: [String] = []) {
        receivedMessages.append(.registerRule(name, content, whitelist))
    }

    func applyRule(name: String) {
        receivedMessages.append(.applyRule(name))
    }

    func removeAllRules() {
        receivedMessages.append(.removeAllRules)
    }

    func load(_ url: URL) {
        receivedMessages.append(.load(url: url))
    }

    func didTapBackButton() {
        receivedMessages.append(.didTapBackButton)
    }

    func didTapForwardButton() {
        receivedMessages.append(.didTapForwardButton)
    }

    func canGoBack() -> Bool {
        receivedMessages.append(.canGoBack)
        return true
    }

    func canGoForward() -> Bool {
        receivedMessages.append(.canGoForward)
        return true
    }
}
