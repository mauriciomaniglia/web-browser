import SwiftUI

struct MenuView: View {
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkView(viewModel: bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: HistoryView(viewModel: historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
