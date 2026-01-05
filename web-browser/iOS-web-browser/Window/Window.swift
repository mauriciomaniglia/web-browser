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
