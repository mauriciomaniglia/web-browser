import SwiftUI

struct MenuView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                if tabViewModel.showWebView {
                    AddBookmarkButton
                }
                NavigationLink(destination: BookmarkView(viewModel: bookmarkViewModel, isPresented: $isPresented)) {
                    Label("Bookmarks", systemImage: "book")
                }
                NavigationLink(destination: HistoryView(viewModel: historyViewModel, isPresented: $isPresented)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                if let url = URL(string: tabViewModel.fullURL) {
                    ShareLink(item: url) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .tint(.primary)
                    }
                }
            }
        }
    }

    var AddBookmarkButton: some View {
        Button(action: {
            tabViewModel.didTapAddBookmark()
            isPresented = false
        }) {
            HStack {
                Label("Add Bookmark", systemImage: "bookmark")
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
