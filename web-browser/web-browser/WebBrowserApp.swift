import SwiftUI

@main
struct WebBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            AnyView(composeView())
        }
    }
}
