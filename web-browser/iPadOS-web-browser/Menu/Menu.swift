import SwiftUI

struct Menu: View {
    @ObservedObject var tabViewModel: TabViewModel

    @Binding var isShowingMenu: Bool
    @Binding var isShowingBookmarks: Bool
    @Binding var isShowingHistory: Bool

    // MARK: - Body

    var body: some View {
        VStack {
            List {
                if tabViewModel.showWebView {
                    addBookmarkButton
                }
                bookmarksButton
                historyButton
            }
        }
        .frame(width: 500, height: 500)
    }

    // MARK: - Buttons

    var addBookmarkButton: some View {
        Button(action: {
            isShowingMenu.toggle()
            tabViewModel.didTapAddBookmark()
        }) {
            Label("Add Bookmark", systemImage: "bookmark")
        }
    }

    var bookmarksButton: some View {
        Button(action: {
            isShowingMenu.toggle()
            isShowingBookmarks.toggle()
        }) {
            Label("Bookmarks", systemImage: "book")
        }
    }

    var historyButton: some View {
        Button(action: {
            isShowingMenu.toggle()
            isShowingHistory.toggle()
        }) {
            Label("History", systemImage: "clock.arrow.circlepath")
        }
    }
}
