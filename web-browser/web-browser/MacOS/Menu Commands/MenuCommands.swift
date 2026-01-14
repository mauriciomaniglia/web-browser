import SwiftUI

struct MenuCommands: Commands {
    let tabBarManager: TabBarManager

    var body: some Commands {
        CommandMenu("Bookmarks") {
            Button("Add Bookmark...") {
                tabBarManager.selectedTab?.tabViewModel.didTapAddBookmark()
            }
            .keyboardShortcut("d", modifiers: [.command])
        }
    }
}
