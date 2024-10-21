import SwiftUI

#if os(macOS)
struct MacOSMenu: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkView(viewModel: windowViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: MacOSHistoryView(viewModel: windowViewModel.historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
