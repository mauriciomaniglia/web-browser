import SwiftUI

@main
struct WebBrowserApp: App {
    let composer = WindowComposer()

    var body: some Scene {
        WindowGroup {
            AnyView(composer.composeView())
        }
        .commands {
            CommandMenu("Bookmarks") {
                Button("Add Bookmark") {
                    addBookmark()
                }
                .keyboardShortcut("D", modifiers: .command)

                Button("Show Bookmarks") {
                    showBookmarks()
                }
                .keyboardShortcut("B", modifiers: [.command, .shift])
            }
        }
    }

    private func addBookmark() {
        print("Add Bookmark")
    }

    private func showBookmarks() {
        print("Show Bookmarks")
    }
}
