import SwiftUI

#if canImport(UIKit)
struct BrowserTabView<Content: View>: UIViewControllerRepresentable {
    let contentProvider: () -> Content

    func makeUIViewController(context: Context) -> BrowserTabViewController<Content> {
        BrowserTabViewController(contentProvider: contentProvider)
    }

    func updateUIViewController(_ uiViewController: BrowserTabViewController<Content>, context: Context) {}
}
#endif

#if canImport(AppKit)
struct BrowserTabView<Content: View>: NSViewControllerRepresentable {
    let contentProvider: () -> Content

    func makeNSViewController(context: Context) -> BrowserTabViewController<Content> {
        return BrowserTabViewController(contentProvider: contentProvider)
    }

    func updateNSViewController(_ nsViewController: BrowserTabViewController<Content>, context: Context) {}
}
#endif
