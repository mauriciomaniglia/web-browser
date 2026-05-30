import SwiftUI

struct MenuView: View {
    @ObservedObject var menuViewModel: MenuViewModel

    var body: some View {
        List {
            Button(action: menuViewModel.navigateToBookmarks) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            Button(action: menuViewModel.navigateToHistory) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .buttonStyle(.borderless)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
