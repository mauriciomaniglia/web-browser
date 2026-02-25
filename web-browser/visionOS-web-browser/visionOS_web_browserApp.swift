import SwiftUI

@main
struct visionOS_web_browserApp: App {
    let windowComposer = WindowComposer()
    
    var body: some Scene {
        WindowGroup {
            windowComposer.createNewWindow()
        }
    }
}
