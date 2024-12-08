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
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        WindowNavigationButtons(viewModel: windowViewModel)
                    }
                    ToolbarItem(placement: .principal) {
                        AddressBarView(viewModel: windowViewModel)
                    }
                    if windowViewModel.canShowShareButton() {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ShareButton
                        }
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            AddBookmarkAlert
        }
    }

    private var ShareButton: some View {
        ShareLink(item: URL(string: windowViewModel.fullURL)!) {
            Image(systemName: "square.and.arrow.up")
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
