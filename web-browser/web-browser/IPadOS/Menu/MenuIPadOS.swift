import SwiftUI

enum AppScreen: Hashable {
    case bookmarks
}

#if os(iOS)
struct MenuIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        NavigationStack {
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

                NavigationLink(value: AppScreen.bookmarks) {
                    Label("Bookmarks", systemImage: "book")
                }
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .bookmarks:
                    BookmarkIPadOS(viewModel: windowViewModel.bookmarkViewModel)                
                }
            }
        }
    }
}
#endif
