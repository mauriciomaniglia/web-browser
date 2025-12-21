import SwiftUI

struct TabContentView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    @State var isShowingMenu: Bool = false

    let webView: WebView

    var body: some View {
        ZStack(alignment: .top) {
            if tabViewModel.showSearchSuggestions {
                SearchSuggestion
            }
            SearchBar
            Spacer()
            WebView
        }
        .overlay(alignment: .center) {
            AddBookmarkAlert
        }
    }

    var AddBookmarkAlert: some View {
        Group {
            if tabViewModel.showAddBookmark {
                AddBookmark(
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

    var SearchBar: some View {
        HStack {
            WindowNavigationButtons(viewModel: tabViewModel)
            AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            MenuButton
            if let url = URL(string: tabViewModel.fullURL) {
                ShareLink(item: url) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .padding()
    }

    var MenuButton: some View {
        Button(action: { isShowingMenu.toggle() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $isShowingMenu, content: {
            Menu(tabViewModel: tabViewModel,
                 bookmarkViewModel: bookmarkViewModel,
                 historyViewModel: historyViewModel)
        })
    }

    var SearchSuggestion: some View {
        SearchSuggestionView(viewModel: searchSuggestionViewModel)
            .frame(width: 550)
            .offset(y: 55)
            .zIndex(2)
    }

    var WebView: some View {
        webView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
            .offset(y: 75)
            .zIndex(1)
    }
}
