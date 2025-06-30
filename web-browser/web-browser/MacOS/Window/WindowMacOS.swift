import SwiftUI

#if os(macOS)
struct WindowMacOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuMacOS(windowViewModel: windowViewModel)
            } detail: {
                VStack {
                    HStack {
                        WindowNavigationButtons(viewModel: windowViewModel)

                        Spacer()

                        AddressBarView(viewModel: windowViewModel, searchText: windowViewModel.fullURL)
                            .frame(minWidth: 0, maxWidth: 800)

                        Spacer()

                        if windowViewModel.canShowShareButton() {
                            ShareButton
                        }
                    }
                    Spacer()
                    webView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
            }

            if windowViewModel.showAddBookmark {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                AddBookmark
            }

            if windowViewModel.showSearchSuggestions {
                SearchSuggestion
            }
        }
    }

    private var ShareButton: some View {
        ShareLink(item: URL(string: windowViewModel.fullURL)!) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 17))
        }
        .buttonStyle(.borderless)
    }

    private var AddBookmark: some View {
        AddBookmarkMacOS(
            viewModel: windowViewModel,
            isPresented: $windowViewModel.showAddBookmark,
            bookmarkName: windowViewModel.urlHost,
            bookmarkURL: windowViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(1)
    }

    private var SearchSuggestion: some View {
        SearchSuggestionView(viewModel: windowViewModel.searchSuggestionViewModel)
            .frame(width: 800, alignment: .top)
            .offset(
                x: 45,
                y: 60
            )
            .zIndex(2)
            .transition(.opacity)
            .animation(.easeInOut, value: windowViewModel.showSearchSuggestions)
    }
}
#endif
