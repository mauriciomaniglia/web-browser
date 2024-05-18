@testable import core_web_browser

class WindowPresenterSpy: WindowPresenter {
    enum Message: Equatable {
        case didStartEditing
        case didEndEditing
        case didLoadPage(isOnWhitelist: Bool?, canGoBack: Bool, canGoForward: Bool)
        case didUpdateProgressBar(value: Double)
    }

    var receivedMessages = [Message]()

    override func didStartEditing() {
        receivedMessages.append(.didStartEditing)
    }

    override func didEndEditing() {
        receivedMessages.append(.didEndEditing)
    }

    override func didLoadPage(url: String, isOnWhitelist: Bool?, canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didLoadPage(isOnWhitelist: isOnWhitelist, canGoBack: canGoBack, canGoForward: canGoForward))
    }

    override func didUpdateProgressBar(_ value: Double) {
        receivedMessages.append(.didUpdateProgressBar(value: value))
    }
}
