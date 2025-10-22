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
