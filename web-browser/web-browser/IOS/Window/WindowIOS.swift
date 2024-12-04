import SwiftUI

#if os(iOS)
struct WindowIOS: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @State var isShowingSheet = false

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: windowViewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)
                Spacer()
                if canShowShareButton {
                    ShareButton
                }
                Spacer()
                Button(action: { isShowingSheet.toggle() }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding()
        }
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

    private var canShowShareButton: Bool {
        !windowViewModel.fullURL.isEmpty
    }

    private var ShareButton: some View {
        ShareLink(item: URL(string: windowViewModel.fullURL)!) {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

#endif
