import Foundation
@testable import Core

class WindowPresenterSpy: WindowPresenter {
    enum Message: Equatable {
        case didStartEditing
        case didEndEditing
        case didLoadPage
        case didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool)
        case didUpdateProgressBar(value: Double)
        case didLoadBackList
        case didLoadForwardList
        case didDismissBackForwardList
    }

    var receivedMessages = [Message]()

    override func didStartEditing() {
        receivedMessages.append(.didStartEditing)
    }

    override func didEndEditing() {
        receivedMessages.append(.didEndEditing)
    }

    override func didLoadPage(url: URL) {
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
