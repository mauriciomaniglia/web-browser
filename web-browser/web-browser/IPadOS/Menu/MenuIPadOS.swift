import SwiftUI

#if os(iOS)
struct MenuIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        List {
            NavigationLink(destination: BookmarkIPadOS(viewModel: windowViewModel.bookmarkViewModel)) {
                Label("Bookmarks", systemImage: "bookmark")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
