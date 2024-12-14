import SwiftUI

#if os(visionOS)
struct WindowVisionOS: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State var isShowingSheet = false

    let webView: AnyView

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            MenuVisionOS(windowViewModel: windowViewModel)
        } detail: {
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.top),
            contentAlignment: .center
        ) {
            HStack {
                Spacer()
                Button(action: toggleNavigationSplitVisibility) {
                    Image(systemName: "sidebar.left")
                }
                Spacer(minLength: 20)
                WindowNavigationButtons(viewModel: windowViewModel)
                AddressBarView(viewModel: windowViewModel, searchText: windowViewModel.fullURL)
                if windowViewModel.canShowShareButton() {
                    ShareButton
                }
            }
            .frame(width: 1000)
            .padding()
            .glassBackgroundEffect()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
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
                AddBookmarkVisionOS(
                    viewModel: windowViewModel,
                    bookmarkName: windowViewModel.title,
                    bookmarkURL: windowViewModel.fullURL
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(windowViewModel.showAddBookmark ? Color.black.opacity(0.3) : Color.clear)
    }

    private func toggleNavigationSplitVisibility() {
        if columnVisibility == .detailOnly {
            columnVisibility = .all
        } else {
            columnVisibility = .detailOnly
        }
    }
}
#endif
