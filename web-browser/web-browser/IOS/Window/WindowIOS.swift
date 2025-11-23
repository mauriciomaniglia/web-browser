import SwiftUI

#if os(iOS)
struct WindowIOS: View {
    @ObservedObject var tabViewModel: TabViewModel
    @State var isShowingSheet = false

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)

            if tabViewModel.showSearchSuggestions {
                ScrollView {
                    SearchSuggestionView(viewModel: tabViewModel.searchSuggestionViewModel)
                }
            } else {
                webView
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .opacity(tabViewModel.showWebView ? 1 : 0)
            }

            HStack {
                WindowNavigationButtons(viewModel: tabViewModel)
                Spacer()
                Button(action: { isShowingSheet.toggle() }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            MenuIOS(tabViewModel: tabViewModel, isPresented: $isShowingSheet)
        })
        .popover(isPresented: $tabViewModel.showAddBookmark, arrowEdge: .trailing, content: {
            AddBookmarkIOS(
                viewModel: tabViewModel,
                bookmarkName: tabViewModel.title,
                bookmarkURL: tabViewModel.fullURL
            )
        })
    }
}

#endif
