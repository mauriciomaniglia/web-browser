import SwiftUI

struct TabContentView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    @State var isShowingMenu: Bool = false
    @State var isShowingBookmarks: Bool = false
    @State var isShowingHistory: Bool = false

    let webView: WebView

    var body: some View {
        ZStack(alignment: .top) {
            searchBar
            if shouldShowSearchSuggestions {
                searchSuggestions
            }
            Spacer()
            webViewFrame
        }
        .overlay(alignment: .center) {
            if tabViewModel.showAddBookmark {
                addBookmarkAlert
            } else if isShowingBookmarks {
                bookmarkAlert
            } else if isShowingHistory {
                historyAlert
            }
        }
    }

    var shouldShowSearchSuggestions: Bool {
        tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        SearchSuggestionView(viewModel: searchSuggestionViewModel)
            .frame(width: 550)
            .offset(y: 55)
            .zIndex(2)
    }

    var searchBar: some View {
        HStack {
            NavigationBar(viewModel: tabViewModel)
            AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            menuButton
            if let url = URL(string: tabViewModel.fullURL) {
                ShareLink(item: url) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .padding()
    }

    var menuButton: some View {
        Button(action: { isShowingMenu.toggle() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $isShowingMenu, content: {
            MenuView(tabViewModel: tabViewModel,
                 isShowingMenu: $isShowingMenu,
                 isShowingBookmarks: $isShowingBookmarks,
                 isShowingHistory: $isShowingHistory)
        })
    }

    var webViewFrame: some View {
        webView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
            .offset(y: 75)
            .zIndex(1)
    }

    var addBookmarkAlert: some View {
        Group {
            AddBookmark(
                tabViewModel: tabViewModel,
                bookmarkViewModel: bookmarkViewModel,
                bookmarkName: tabViewModel.title,
                bookmarkURL: tabViewModel.fullURL
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }

    var bookmarkAlert: some View {
        Group {
            Bookmark(viewModel: bookmarkViewModel, isShowingBookmarks: $isShowingBookmarks)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }

    var historyAlert: some View {
        Group {
            History(viewModel: historyViewModel, isShowingHistory: $isShowingHistory)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }
}
