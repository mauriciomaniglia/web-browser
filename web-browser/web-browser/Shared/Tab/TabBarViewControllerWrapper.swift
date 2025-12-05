import SwiftUI

#if canImport(UIKit)
struct TabBarViewControllerWrapper: UIViewControllerRepresentable {
    let windowComposer: WindowComposer

    func makeUIViewController(context: Context) -> TabBarViewController {
        TabBarViewController(windowComposer: windowComposer)
    }

    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {}
}
#endif

#if canImport(AppKit)
struct TabBarViewControllerWrapper: NSViewControllerRepresentable {
    let windowComposer: WindowComposer

    func makeNSViewController(context: Context) -> TabBarViewController {
        return TabBarViewController(windowComposer: windowComposer)
    }

    func updateNSViewController(_ nsViewController: TabBarViewController, context: Context) {}
}
#endif
