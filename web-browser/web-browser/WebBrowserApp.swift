import SwiftUI

@main
struct WebBrowserApp: App {
    let windowComposer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            windowComposer.createNewWindow()
        }
        .commands {
            MenuCommands(tabManager: windowComposer.tabManager)
        }
    }
}
