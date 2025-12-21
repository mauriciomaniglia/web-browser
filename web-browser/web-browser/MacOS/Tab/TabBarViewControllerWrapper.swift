import SwiftUI

struct TabBarViewControllerWrapper: NSViewControllerRepresentable {
    let tabManager: TabManager

    func makeNSViewController(context: Context) -> TabBarViewController {
        return TabBarViewController(tabManager: tabManager)
    }

    func updateNSViewController(_ nsViewController: TabBarViewController, context: Context) {}
}
