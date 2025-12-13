import SwiftUI

struct TabBarViewControllerWrapper: UIViewControllerRepresentable {
    let windowComposer: WindowComposer

    func makeUIViewController(context: Context) -> TabBarViewController {
        TabBarViewController(windowComposer: windowComposer)
    }

    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {}
}
