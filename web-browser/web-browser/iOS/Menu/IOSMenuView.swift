import SwiftUI

#if os(iOS)
struct IOSMenuView: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                Button(action: {                    
                    print("Performing custom action for Add Bookmark")
                }) {
                    HStack {
                        Label("Add Bookmark", systemImage: "bookmark")
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: IOSBookmarkView(viewModel: windowViewModel.bookmarkViewModel)) {
                    Label("Bookmarks", systemImage: "book")
                }
                NavigationLink(destination: IOSHistoryView(viewModel: windowViewModel.historyViewModel, isPresented: $isPresented)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
    }
}
#endif
