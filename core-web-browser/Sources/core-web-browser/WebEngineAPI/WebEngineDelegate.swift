import Foundation

public protocol WebEngineDelegate {
    func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool)
    func didUpdateLoadingProgress(_ progress: Double)
}
