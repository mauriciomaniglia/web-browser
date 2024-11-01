import SwiftUI

#if os(macOS)
struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MacOSMenu(windowViewModel: windowViewModel)
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
                AddBookmarkView
            }
        }
    }

    private var AddBookmarkView: some View {
        MacAddBookmarkView(
            viewModel: windowViewModel,
            isPresented: $windowViewModel.showAddBookmark,
            name: windowViewModel.urlHost ?? ""
        )
        .transition(.scale)
        .zIndex(1)
    }
}
#endif
