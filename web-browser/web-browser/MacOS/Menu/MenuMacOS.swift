import SwiftUI

#if os(macOS)
struct MenuMacOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkMacOS(viewModel: windowViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: HistoryMacOS(viewModel: windowViewModel.historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
