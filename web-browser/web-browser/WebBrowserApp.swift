import SwiftUI

@main
struct WebBrowserApp: App {
    let windowComposer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                TabBarViewControllerWrapper(windowComposer: windowComposer)
            } else {
                AnyView(windowComposer.createNewTab().view)
            }
            #endif

            #if os(macOS)
            WindowMacOS(
                windowComposer: windowComposer,
                tabViewModel: windowComposer.selectedTab.tabViewModel,
                bookmarkViewModel: windowComposer.bookmarkComposer.viewModel,
                historyViewModel: windowComposer.historyComposer.viewModel
            )
            #endif
        }
    }
}
