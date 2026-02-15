import SwiftUI

struct MenuCommands: Commands {
    let tabBarManager: TabBarManager<TabSessionStore>

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("New Tab") {
                tabBarManager.createNewTab()
            }
            .keyboardShortcut("t", modifiers: [.command])
        }

        CommandMenu("Bookmarks") {
            Button("Add Bookmark...") {
                tabBarManager.selectedTab?.tabViewModel.didTapAddBookmark()
            }
            .keyboardShortcut("d", modifiers: [.command])
        }
    }
}
