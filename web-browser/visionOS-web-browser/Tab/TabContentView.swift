import SwiftUI

struct TabContentView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    let webView: WebView

    var body: some View {
        ZStack(alignment: .top) {
            webViewFrame
            if shouldShowAddBookmark {
                addBookmarkDialog
            }
        }
        .padding()
    }

    var webViewFrame: some View {
        webView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
            .offset(y: 60)
            .zIndex(1)
    }

    var shouldShowAddBookmark: Bool {
        tabViewModel.showAddBookmark
    }

    var addBookmarkDialog: some View {
        AddBookmarkView(
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            isPresented: $tabViewModel.showAddBookmark,
            bookmarkName: tabViewModel.urlHost,
            bookmarkURL: tabViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(3)
    }
}
