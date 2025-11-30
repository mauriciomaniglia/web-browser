import SwiftUI

@main
struct WebBrowserApp: App {
    let tabViewFactory = TabViewFactory()

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                TabBarViewControllerWrapper(tabFactory: tabViewFactory)
            } else {
                AnyView(tabViewFactory.createNewTab().view)
            }
            #endif

            #if os(macOS)
            WindowMacOS(
                tabFactory: tabViewFactory,
                tabViewModel: tabViewFactory.selectedTab.tabViewModel,
                bookmarkViewModel: tabViewFactory.bookmarkComposer.viewModel,
                historyViewModel: tabViewFactory.historyComposer.viewModel
            )
            #endif
        }
    }
}
