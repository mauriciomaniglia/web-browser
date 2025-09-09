import SwiftUI

#if os(iOS)
struct WindowIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuIPadOS(windowViewModel: windowViewModel)
            } detail: {
                VStack {
                    webView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(windowViewModel.showWebView ? 1 : 0)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        WindowNavigationButtons(viewModel: windowViewModel)
                    }
                    ToolbarItem(placement: .principal) {
                        AddressBarView(viewModel: windowViewModel, searchText: $windowViewModel.fullURL)
                            .popover(isPresented: $windowViewModel.showSearchSuggestions, attachmentAnchor: .point(.bottom)) {
                                SearchSuggestionView(viewModel: windowViewModel.searchSuggestionViewModel)
                                    .frame(width: 550)
                            }
                    }
                    if let url = URL(string: windowViewModel.fullURL) {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ShareLink(item: url) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            AddBookmarkAlert
        }
    }

    private var AddBookmarkAlert: some View {
        Group {
            if windowViewModel.showAddBookmark {
                AddBookmarkIPadOS(
                    viewModel: windowViewModel,
                    bookmarkName: windowViewModel.title,
                    bookmarkURL: windowViewModel.fullURL
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(windowViewModel.showAddBookmark ? Color.black.opacity(0.3) : Color.clear)
    }
}
#endif
