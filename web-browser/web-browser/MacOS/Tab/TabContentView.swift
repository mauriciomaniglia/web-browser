import SwiftUI

struct TabContentView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    let webView: WebView

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            mainToolbar
            if shouldShowSearchSuggestions {
                searchSuggestions
            }
            Spacer()
            webViewFrame
            if shouldShowAddBookmark {
                addBookmarkDialog
            }
        }
        .padding()
    }

    // MARK: - Toolbar

    var mainToolbar: some View {
        HStack {
            navigationButtons
            Spacer()
            addressBar
            Spacer()
            if let url = URL(string: tabViewModel.fullURL) {
                shareLink(url)
            }
        }
    }

    var navigationButtons: some View {
        NavigationBar(viewModel: tabViewModel)
    }

    var addressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            .frame(minWidth: 0, maxWidth: 800)
    }

    func shareLink(_ url: URL) -> some View {
        ShareLink(item: url) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 17))
        }
        .buttonStyle(.borderless)
    }

    // MARK: - Search Suggestion

    var shouldShowSearchSuggestions: Bool {
        tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        SearchSuggestionView(viewModel: searchSuggestionViewModel)
            .frame(width: 550)
            .offset(y: 42)
            .zIndex(2)
    }

    // MARK: - Web View

    var webViewFrame: some View {
        webView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
            .offset(y: 60)
            .zIndex(1)
    }

    // MARK: - Bookmark

    var shouldShowAddBookmark: Bool {
        tabViewModel.showAddBookmark
    }

    var addBookmarkDialog: some View {
        AddBookmark(
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
