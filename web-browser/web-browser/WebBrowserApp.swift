import SwiftUI

@main
struct WebBrowserApp: App {
    let tabViewFactory = TabViewFactory()
    let commandMenuViewModel = CommandMenuViewModel()

    var body: some Scene {
        WindowGroup {
            AnyView(tabViewFactory.createNewTab())
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
