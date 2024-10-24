import SwiftUI

#if os(iOS)
struct IOSMenuView: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: IOSBookmarkView(viewModel: windowViewModel.bookmarkViewModel)) {
                    Label("Bookmarks", systemImage: "bookmark")
                }
                NavigationLink(destination: IOSHistoryView(viewModel: windowViewModel.historyViewModel, isPresented: $isPresented)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
    }
}
#endif
