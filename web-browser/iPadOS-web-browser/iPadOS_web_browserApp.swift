import SwiftUI

@main
struct iPadOS_web_browserApp: App {
    let windowComposer = WindowComposer()
    
    var body: some Scene {
        WindowGroup {
            TabBarViewControllerWrapper(windowComposer: windowComposer)
        }
    }
}
