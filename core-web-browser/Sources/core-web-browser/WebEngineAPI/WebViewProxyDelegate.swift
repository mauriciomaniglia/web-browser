import Foundation

public protocol WebViewProxyDelegate {
    func didLoadPage(url: URL, canGoBack: Bool, canGoForward: Bool)
    func didUpdateLoadingProgress(_ progress: Double)
}
