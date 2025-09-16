import SwiftUI

#if os(iOS)
struct MenuIPadOS: View {

    enum Menu: Hashable {
        case bookmarks
        case history
    }

    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        NavigationStack {
            List {
                if windowViewModel.showWebView {
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
                    BookmarkIPadOS(viewModel: windowViewModel.bookmarkViewModel)
                case .history:
                    HistoryIPadOS(viewModel: windowViewModel.historyViewModel)
                }
            }
        }
    }

    var AddBookmarkButton: some View {
        Button(action: { windowViewModel.showAddBookmark = true }) {
            Label("Add Bookmark", systemImage: "bookmark")
        }
    }
}
#endif
