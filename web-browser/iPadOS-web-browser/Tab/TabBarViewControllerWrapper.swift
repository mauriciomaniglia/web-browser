import SwiftUI

struct TabBarViewControllerWrapper: UIViewControllerRepresentable {
    let tabManager: TabManager

    func makeUIViewController(context: Context) -> TabBarViewController {
        TabBarViewController(tabManager: tabManager)
    }

    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {}
}
