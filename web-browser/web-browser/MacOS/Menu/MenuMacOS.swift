import SwiftUI

#if os(macOS)
struct MenuMacOS: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkMacOS(viewModel: tabViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: HistoryMacOS(viewModel: historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
