import SwiftUI

#if os(visionOS)
struct VisionOSMenu: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkView(viewModel: windowViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
            NavigationLink(destination: VisionOSHistoryView(viewModel: windowViewModel.historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
