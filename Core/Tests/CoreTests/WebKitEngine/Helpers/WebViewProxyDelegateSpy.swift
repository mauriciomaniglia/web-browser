import Core

class WebViewProxyDelegateSpy: WebEngineDelegate {
    enum Message: Equatable {
        case didLoadPage
        case didUpdateLoadingProgress(_: Double)
        case didUpdateNavigationButtons
    }

    var receivedMessages = [Message]()

    func didLoad(page: WebPage) {
        receivedMessages.append(.didLoadPage)
    }

    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool) {
        receivedMessages.append(.didUpdateNavigationButtons)
    }

    func didUpdateLoadingProgress(_ progress: Double) {
        receivedMessages.append(.didUpdateLoadingProgress(progress))
    }
}
