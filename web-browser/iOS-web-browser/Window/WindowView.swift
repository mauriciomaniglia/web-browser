import SwiftUI

struct WindowView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @ObservedObject var tabBarManager: TabBarManager

    var body: some View {
        Group {
            if let selectedTab = tabBarManager.selectedTab {
                WindowContent(
                    tabViewModel: selectedTab.tabViewModel,
                    historyViewModel: historyViewModel,
                    bookmarkViewModel: bookmarkViewModel,
                    searchSuggestionViewModel: searchSuggestionViewModel,
                    tabBarManager: tabBarManager,
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
    @ObservedObject var tabBarManager: TabBarManager

    @State var isShowingSheet = false
    @State private var isShowingTabManager = false

    let webView: WebView

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
            tabManagerView
        }
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            menuAlert
        })
        .popover(isPresented: $tabViewModel.showAddBookmark, arrowEdge: .trailing, content: {
            addBookmarkAlert
        })
    }

    var addressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
    }

    var shouldShowSearchSuggestions: Bool {
        tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        ScrollView {
            SearchSuggestionView(viewModel: searchSuggestionViewModel)
        }
    }

    var webViewFrame: some View {
        webView
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .opacity(tabViewModel.showWebView ? 1 : 0)
    }

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
            .buttonStyle(PlainButtonStyle())
    }

    var addNewTabButton: some View {
        TabCountButton(count: tabBarManager.tabs.count) {
            isShowingTabManager = true
            tabBarManager.captureSnapshots {
                isShowingTabManager = true
            }
        }
    }

    var menuButton: some View {
        Button(action: { isShowingSheet.toggle() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
    }

    var tabManagerView: some View {
        TabManagerView(tabBarManager: tabBarManager, isPresented: $isShowingTabManager)
    }

    var menuAlert: some View {
        MenuView(
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            historyViewModel: historyViewModel,
            isPresented: $isShowingSheet
        )
        .presentationDetents([.fraction(0.3), .large])
    }

    var addBookmarkAlert: some View {
        AddBookmarkView(
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            bookmarkName: tabViewModel.title,
            bookmarkURL: tabViewModel.fullURL
        )
        .presentationDetents([.fraction(0.3), .medium])
    }
}

