import SwiftUI

struct Window: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var tabManager: TabManager

    var body: some View {
        Group {
            if let selectedTab = tabManager.selectedTab {
                WindowContent(
                    tabViewModel: selectedTab.tabViewModel,
                    historyViewModel: historyViewModel,
                    bookmarkViewModel: bookmarkViewModel,
                    searchSuggestionViewModel: searchSuggestionViewModel,
                    tabManager: tabManager,
                    webView: WebView(content: selectedTab.webKitWrapper.webView)
                )
                .id(selectedTab.id)
            } else {
                Text("No Tabs Open")
            }
        }
    }
}

struct WindowContent: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var tabManager: TabManager

    @State var isShowingSheet = false
    @State private var isShowingTabManager = false

    let webView: WebView

    // MARK: - Body

    var body: some View {
        VStack {
            addressBar
            if shouldShowSearchSuggestions {
                searchSuggestions
            } else {
                webViewFrame
            }
            bottomBar
        }
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $isShowingTabManager) {
            tabManagerScreen
        }
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            menuAlert
        })
        .popover(isPresented: $tabViewModel.showAddBookmark, arrowEdge: .trailing, content: {
            addBookmarkAlert
        })
    }

    // MARK: - Address Bar

    var addressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
    }

    // MARK: - Search Suggestions

    var shouldShowSearchSuggestions: Bool {
        tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        ScrollView {
            SearchSuggestionView(viewModel: searchSuggestionViewModel)
        }
    }

    // MARK: - WebView Frame

    var webViewFrame: some View {
        webView
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
    }

    // MARK: - Bottom Bar

    var bottomBar: some View {
        HStack {
            navigationButton
            Spacer()
            addNewTabButton
            Spacer()
            menuButton
        }
        .padding()
    }

    var navigationButton: some View {
        NavigationBar(viewModel: tabViewModel)
    }

    var addNewTabButton: some View {
        Button(action: { isShowingTabManager = true }) {
            Image(systemName: "plus.square")
        }
    }

    var menuButton: some View {
        Button(action: { isShowingSheet.toggle() }) {
            Image(systemName: "line.3.horizontal")
        }
    }

    // MARK: - Tab Manager Screen

    var tabManagerScreen: some View {
        TabManagerScreen(tabManager: tabManager, isPresented: $isShowingTabManager)
    }

    // MARK: - Alerts

    var menuAlert: some View {
        Menu(
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            historyViewModel: historyViewModel,
            isPresented: $isShowingSheet
        )
    }

    var addBookmarkAlert: some View {
        AddBookmark(
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            bookmarkName: tabViewModel.title,
            bookmarkURL: tabViewModel.fullURL
        )
    }
}
