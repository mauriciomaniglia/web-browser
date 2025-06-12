import Foundation
@testable import Services

class WindowPresenterSpy: WindowPresenter {
    enum Message: Equatable {
        case didChangeFocus(isFocused: Bool)
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

    override func didLoadPage(title: String?, url: URL) {
        receivedMessages.append(.didLoadPage)
    }

    override func didUpdateProgressBar(_ value: Double) {
        receivedMessages.append(.didUpdateProgressBar(value: value))
    }

    override func didLoadBackList(_ webPages: [WindowPageModel]) {
        receivedMessages.append(.didLoadBackList)
    }

    override func didLoadForwardList(_ webPages: [WindowPageModel]) {
        receivedMessages.append(.didLoadForwardList)
    }

    override func didDismissBackForwardList() {
        receivedMessages.append(.didDismissBackForwardList)
    }

    override func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didUpdateNavigationButtons(canGoBack: canGoBack, canGoForward: canGoForward))
    }
}
