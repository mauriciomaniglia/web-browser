import SwiftUI

#if os(iOS)
struct MenuIPadOS: View {

    enum Menu: Hashable {
        case bookmarks
        case history
    }

    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        NavigationStack {
            List {
                if tabViewModel.showWebView {
                    AddBookmarkButton
                }
                NavigationLink(value: Menu.bookmarks) {
                    Label("Bookmarks", systemImage: "book")
                }
                NavigationLink(value: Menu.history) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
            .navigationDestination(for: Menu.self) { screen in
                switch screen {
                case .bookmarks:
                    BookmarkIPadOS(viewModel: tabViewModel.bookmarkViewModel)
                case .history:
                    HistoryIPadOS(viewModel: historyViewModel)
                }
            }
        }
    }

    var AddBookmarkButton: some View {
        Button(action: { tabViewModel.showAddBookmark = true }) {
            Label("Add Bookmark", systemImage: "bookmark")
        }
    }
}
#endif
