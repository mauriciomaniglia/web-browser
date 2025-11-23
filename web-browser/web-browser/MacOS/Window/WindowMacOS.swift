import SwiftUI

#if os(macOS)

struct WindowMacOS: View {
    let tabFactory: TabViewFactory

    @ObservedObject var tabViewModel: TabViewModel

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuMacOS(tabViewModel: tabViewModel)
            } detail: {
                TabBarViewControllerWrapper(tabFactory: tabFactory)
            }

            if tabViewModel.showAddBookmark {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                AddBookmark
            }
        }
    }

    // MARK: SubViews

    var AddBookmark: some View {
        AddBookmarkMacOS(
            viewModel: tabViewModel,
            isPresented: $tabViewModel.showAddBookmark,
            bookmarkName: tabViewModel.urlHost,
            bookmarkURL: tabViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(1)
    }
}
#endif
