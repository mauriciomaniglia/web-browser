import SwiftUI

#if os(visionOS)
struct MenuVisionOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        List {
            Button(action: {
                windowViewModel.showAddBookmark = true
            }) {
                HStack {
                    Label("Add Bookmark", systemImage: "bookmark")
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())

            NavigationLink(destination: BookmarkView(viewModel: windowViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "book")
            }
            NavigationLink(destination: HistoryVisionOS(viewModel: windowViewModel.historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
