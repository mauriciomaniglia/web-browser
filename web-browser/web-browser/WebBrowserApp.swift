import SwiftUI

@main
struct WebBrowserApp: App {
    let tabViewFactory = TabViewFactory()

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                TabBarViewControllerWrapper {
                    AnyView(tabViewFactory.createNewTab().windowComposer.view)
                }
                .ignoresSafeArea()
            } else {
                AnyView(tabViewFactory.createNewTab().windowComposer.view)
            }
            #endif

            #if os(macOS)
            let windowComposer = tabViewFactory.createNewTab().windowComposer
            WindowMacOS(
                tabFactory: tabViewFactory,
                windowViewModel: windowComposer.windowViewModel
            )
            #endif
        }
    }
}
