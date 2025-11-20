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
struct BrowserTabView: NSViewControllerRepresentable {
    let tabFactory: TabViewFactory

    func makeNSViewController(context: Context) -> BrowserTabViewController {
        return BrowserTabViewController(tabFactory: tabFactory)
    }

    func updateNSViewController(_ nsViewController: BrowserTabViewController, context: Context) {}
}
#endif
