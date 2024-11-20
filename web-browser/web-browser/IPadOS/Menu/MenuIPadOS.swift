import SwiftUI

enum AppScreen: Hashable {
    case bookmarks
    case history
}

#if os(iOS)
struct MenuIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        NavigationStack {
            List {
                Button(action: { windowViewModel.showAddBookmark = true }) {
                    Label("Add Bookmark", systemImage: "bookmark")
                }
                NavigationLink(value: AppScreen.bookmarks) {
                    Label("Bookmarks", systemImage: "book")
                }
                NavigationLink(value: AppScreen.history) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .bookmarks:
                    BookmarkIPadOS(viewModel: windowViewModel.bookmarkViewModel)
                case .history:
                    HistoryVisionOS(viewModel: windowViewModel.historyViewModel)
                }
            }
        }
    }
}
#endif
