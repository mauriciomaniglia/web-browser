import SwiftUI

@main
struct WebBrowserApp: App {
    let windowComposer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            WindowMacOS(
                windowComposer: windowComposer,
                tabViewModel: windowComposer.selectedTab.tabViewModel,
                bookmarkViewModel: windowComposer.bookmarkComposer.viewModel,
                historyViewModel: windowComposer.historyComposer.viewModel
            )
        }
    }
}
