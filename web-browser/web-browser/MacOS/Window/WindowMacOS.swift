import SwiftUI

#if os(macOS)

struct WindowMacOS: View {
    let tabFactory: TabViewFactory

    @ObservedObject var windowViewModel: WindowViewModel

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuMacOS(windowViewModel: windowViewModel)
            } detail: {
                TabBarViewControllerWrapper(tabFactory: tabFactory)
            }

            if windowViewModel.showAddBookmark {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                AddBookmark
            }
        }
    }

    // MARK: SubViews

    var AddBookmark: some View {
        AddBookmarkMacOS(
            viewModel: windowViewModel,
            isPresented: $windowViewModel.showAddBookmark,
            bookmarkName: windowViewModel.urlHost,
            bookmarkURL: windowViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(1)
    }
}
#endif
