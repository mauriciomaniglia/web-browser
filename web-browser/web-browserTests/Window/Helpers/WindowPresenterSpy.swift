import Foundation
@testable import web_browser
@testable import core_web_browser

class WindowPresenterSpy: WindowPresenter {
    enum Message: Equatable {
        case didStartEditing
        case didEndEditing
        case didLoadPage(canGoBack: Bool, canGoForward: Bool)
        case didUpdateProgressBar(value: Double)
        case didLoadBackList
        case didLoadForwardList
    }

    var receivedMessages = [Message]()

    override func didStartEditing() {
        receivedMessages.append(.didStartEditing)
    }

    override func didEndEditing() {
        receivedMessages.append(.didEndEditing)
    }

    override func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didLoadPage(canGoBack: canGoBack, canGoForward: canGoForward))
    }

    override func didUpdateProgressBar(_ value: Double) {
        receivedMessages.append(.didUpdateProgressBar(value: value))
    }

    override func didLoadBackList(_ webPages: [WebPage]) {
        receivedMessages.append(.didLoadBackList)
    }

    override func didLoadForwardList(_ webPages: [WebPage]) {
        receivedMessages.append(.didLoadForwardList)
    }
}
