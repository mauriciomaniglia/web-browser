import SwiftUI

#if os(iOS)
struct WindowIOS: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @State var isShowingSheet = false

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: windowViewModel, searchText: $windowViewModel.fullURL)

            if windowViewModel.showSearchSuggestions {
                ScrollView {
                    SearchSuggestionView(viewModel: windowViewModel.searchSuggestionViewModel)
                }
            } else {
                webView
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .opacity(windowViewModel.showWebView ? 1 : 0)
            }

            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)
                Spacer()
                Button(action: { isShowingSheet.toggle() }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            MenuIOS(windowViewModel: windowViewModel, isPresented: $isShowingSheet)
        })
        .popover(isPresented: $windowViewModel.showAddBookmark, arrowEdge: .trailing, content: {
            AddBookmarkIOS(
                viewModel: windowViewModel,
                bookmarkName: windowViewModel.title,
                bookmarkURL: windowViewModel.fullURL
            )
        })
    }
}

#endif
