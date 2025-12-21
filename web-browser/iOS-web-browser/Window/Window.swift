import SwiftUI

struct Window: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel
    @State var isShowingSheet = false

    @State private var isShowingTabManager = false
    @StateObject private var tabManager = TabDisplayManager()

    let webView: WebView

    var body: some View {
        VStack {
            AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)

            if tabViewModel.showSearchSuggestions {
                ScrollView {
                    SearchSuggestionView(viewModel: searchSuggestionViewModel)
                }
            } else {
                webView
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .opacity(tabViewModel.showWebView ? 1 : 0)
            }

            HStack {
                WindowNavigationButtons(viewModel: tabViewModel)
                Spacer()
//                Button(action: { isShowingTabManager = true }) {
//                    Image(systemName: "plus.square")
//                }
                Spacer()
                Button(action: { isShowingSheet.toggle() }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $isShowingTabManager) {
            TabManagerScreen(tabManager: tabManager, isPresented: $isShowingTabManager)
        }
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            Menu(
                tabViewModel: tabViewModel,
                bookmarkViewModel: bookmarkViewModel,
                historyViewModel: historyViewModel,
                isPresented: $isShowingSheet
            )
        })
        .popover(isPresented: $tabViewModel.showAddBookmark, arrowEdge: .trailing, content: {
            AddBookmark(
                tabViewModel: tabViewModel,
                bookmarkViewModel: bookmarkViewModel,
                bookmarkName: tabViewModel.title,
                bookmarkURL: tabViewModel.fullURL
            )
        })
    }
}
