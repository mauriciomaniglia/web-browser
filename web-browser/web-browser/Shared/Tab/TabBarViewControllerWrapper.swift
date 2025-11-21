import SwiftUI

#if canImport(UIKit)
struct TabBarViewControllerWrapper<Content: View>: UIViewControllerRepresentable {
    let contentProvider: () -> Content

    func makeUIViewController(context: Context) -> TabBarViewController<Content> {
        TabBarViewController(contentProvider: contentProvider)
    }

    func updateUIViewController(_ uiViewController: TabBarViewController<Content>, context: Context) {}
}
#endif

#if canImport(AppKit)
struct TabBarViewControllerWrapper: NSViewControllerRepresentable {
    let tabFactory: TabViewFactory

    func makeNSViewController(context: Context) -> TabBarViewController {
        return TabBarViewController(tabFactory: tabFactory)
    }

    func updateNSViewController(_ nsViewController: TabBarViewController, context: Context) {}
}
#endif
