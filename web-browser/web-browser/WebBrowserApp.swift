import SwiftUI

@main
struct WebBrowserApp: App {
    let composer = WindowComposer()
    let commandMenuViewModel = CommandMenuViewModel()

    var body: some Scene {
        WindowGroup {
            AnyView(composer.makeWindowView(commandMenuViewModel: commandMenuViewModel))
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
        commandMenuViewModel.didTapAddBookmark?()
    }

    private func showBookmarks() {
        print("Show Bookmarks")
    }
}
