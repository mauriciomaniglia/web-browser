import SwiftUI

@main
struct WebBrowserApp: App {
    let tabViewFactory = TabViewFactory()

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                TabBarViewControllerWrapper {
                    AnyView(tabViewFactory.createNewTab().tabComposer.view)
                }
                .ignoresSafeArea()
            } else {
                AnyView(tabViewFactory.createNewTab().tabComposer.view)
            }
            #endif

            #if os(macOS)
            let windowComposer = tabViewFactory.createNewTab().tabComposer
            WindowMacOS(
                tabFactory: tabViewFactory,
                tabViewModel: windowComposer.tabViewModel
            )
            #endif
        }
    }
}
