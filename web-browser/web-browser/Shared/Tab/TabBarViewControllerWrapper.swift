import SwiftUI

#if canImport(UIKit)
struct TabBarViewControllerWrapper: UIViewControllerRepresentable {
    let tabFactory: TabViewFactory

    func makeUIViewController(context: Context) -> TabBarViewController {
        TabBarViewController(tabFactory: tabFactory)
    }

    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {}
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
