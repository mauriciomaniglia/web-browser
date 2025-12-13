import SwiftUI

#if canImport(AppKit)
struct TabBarViewControllerWrapper: NSViewControllerRepresentable {
    let windowComposer: WindowComposer

    func makeNSViewController(context: Context) -> TabBarViewController {
        return TabBarViewController(windowComposer: windowComposer)
    }

    func updateNSViewController(_ nsViewController: TabBarViewController, context: Context) {}
}
#endif
