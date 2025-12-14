import SwiftUI

@main
struct iOS_web_browserApp: App {
    let windowComposer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            windowComposer.createNewTab().view
        }
    }
}
