import SwiftUI

#if os(iOS)
struct MenuIOS: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    windowViewModel.didTapAddBookmark()
                    isPresented = false
                }) {
                    HStack {
                        Label("Add Bookmark", systemImage: "bookmark")
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: BookmarkIOS(viewModel: windowViewModel.bookmarkViewModel, isPresented: $isPresented)) {
                    Label("Bookmarks", systemImage: "book")
                }
                NavigationLink(destination: HistoryIOS(viewModel: windowViewModel.historyViewModel, isPresented: $isPresented)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                if windowViewModel.canShowShareButton() {
                    ShareButton
                }
            }
        }
    }

    private var ShareButton: some View {
        ShareLink(item: URL(string: windowViewModel.fullURL)!) {
            Label("Share", systemImage: "square.and.arrow.up")
                .tint(.primary)
        }
    }
}
#endif
