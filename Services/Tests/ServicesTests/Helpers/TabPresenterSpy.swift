import Foundation
@testable import Services

class TabPresenterSpy: TabPresenter {
    enum Message: Equatable {
        case didChangeFocus(isFocused: Bool)
        case didStartTyping(oldText: String, newText: String)
        case didLoadPage
        case didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool)
        case didUpdateProgressBar(value: Double)
        case didLoadBackList
        case didLoadForwardList
        case didDismissBackForwardList
    }

    var receivedMessages = [Message]()

    override func didChangeFocus(isFocused: Bool) {
        receivedMessages.append(.didChangeFocus(isFocused: isFocused))
    }

    override func didStartTyping(oldText: String, newText: String) {
        receivedMessages.append(.didStartTyping(oldText: oldText, newText: newText))
    }

    override func didLoadPage(title: String?, url: URL) {
        receivedMessages.append(.didLoadPage)
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

    override func didDismissBackForwardList() {
        receivedMessages.append(.didDismissBackForwardList)
    }

    override func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward))
    }
}
