import Foundation

public protocol WebEngineDelegate {
    func didLoad(page: WebPage)
    func didUpdateNavigationButtons(canGoBack: Bool, canGoForward: Bool)    
    func didUpdateLoadingProgress(_ progress: Double)
}
