import SwiftUI

#if os(macOS)

struct WindowMacOS: View {
    let windowComposer: WindowComposer

    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuMacOS(tabViewModel: tabViewModel, bookmarkViewModel: bookmarkViewModel, historyViewModel: historyViewModel)
            } detail: {
                TabBarViewControllerWrapper(windowComposer: windowComposer)
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
            tabViewModel: tabViewModel,
            bookmarkViewModel: bookmarkViewModel,
            isPresented: $tabViewModel.showAddBookmark,
            bookmarkName: tabViewModel.urlHost,
            bookmarkURL: tabViewModel.fullURL
        )
        .transition(.scale)
        .zIndex(1)
    }
}
#endif
