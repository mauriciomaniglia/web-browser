import SwiftUI

struct Menu: View {

    enum Menu: Hashable {
        case bookmarks
        case history
    }

    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        VStack {
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
                        Bookmark(viewModel: bookmarkViewModel)
                    case .history:
                        History(viewModel: historyViewModel)
                    }
                }
            }
        }
        .frame(width: 500, height: 500)
    }

    var AddBookmarkButton: some View {
        Button(action: { tabViewModel.showAddBookmark = true }) {
            Label("Add Bookmark", systemImage: "bookmark")
        }
    }
}
