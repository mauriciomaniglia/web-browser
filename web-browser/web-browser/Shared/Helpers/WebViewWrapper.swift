import SwiftUI
import WebKit

#if canImport(AppKit)
struct WebView: NSViewRepresentable {
    let content: WKWebView
    func makeNSView(context: Context) -> WKWebView { content }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
#endif

#if canImport(UIKit)
struct WebView: UIViewRepresentable {
    let content: WKWebView
    func makeUIView(context: Context) -> WKWebView { content }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
#endif
