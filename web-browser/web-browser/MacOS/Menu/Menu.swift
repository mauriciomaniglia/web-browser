import SwiftUI

struct Menu: View {
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        List {
            NavigationLink(destination: Bookmark(viewModel: bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: History(viewModel: historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
