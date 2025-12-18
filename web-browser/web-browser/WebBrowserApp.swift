import SwiftUI

@main
struct WebBrowserApp: App {
    let windowComposer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            Window(
                windowComposer: windowComposer,
                bookmarkViewModel: windowComposer.bookmarkComposer.viewModel,
                historyViewModel: windowComposer.historyComposer.viewModel
            )
        }
    }
}
