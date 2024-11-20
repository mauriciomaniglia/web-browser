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
                        AddressBarView(viewModel: windowViewModel)
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
        }
    }

    private var AddBookmark: some View {
        AddBookmarkMacOS(
            viewModel: windowViewModel,
            isPresented: $windowViewModel.showAddBookmark,
            bookmarkName: windowViewModel.urlHost ?? "",
            bookmarkURL: windowViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(1)
    }
}
#endif