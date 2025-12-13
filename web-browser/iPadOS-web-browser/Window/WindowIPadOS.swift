import SwiftUI

#if os(iOS)
struct WindowIPadOS: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel

    let webView: WebView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuIPadOS(
                    tabViewModel: tabViewModel,
                    bookmarkViewModel: bookmarkViewModel,
                    historyViewModel: historyViewModel
                )
            } detail: {
                TabContentViewIPadOS(
                    tabViewModel: tabViewModel,
                    searchSuggestionViewModel: searchSuggestionViewModel,
                    webView: webView
                )
            }
        }
        .overlay(alignment: .center) {
            AddBookmarkAlert
        }
    }

    private var AddBookmarkAlert: some View {
        Group {
            if tabViewModel.showAddBookmark {
                AddBookmarkIPadOS(
                    tabViewModel: tabViewModel,
                    bookmarkViewModel: bookmarkViewModel,
                    bookmarkName: tabViewModel.title,
                    bookmarkURL: tabViewModel.fullURL
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(tabViewModel.showAddBookmark ? Color.black.opacity(0.3) : Color.clear)
    }
}
#endif
