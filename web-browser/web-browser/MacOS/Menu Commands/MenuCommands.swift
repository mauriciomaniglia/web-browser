import SwiftUI

struct MenuCommands: Commands {
    let tabManager: TabManager

    var body: some Commands {
        CommandMenu("Bookmarks") {
            Button("Add Bookmark...") {
                tabManager.selectedTab?.tabViewModel.didTapAddBookmark()
            }
            .keyboardShortcut("d", modifiers: [.command])
        }
    }
}
