import SwiftUI

#if os(iOS)
struct WindowIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuIPadOS(windowViewModel: windowViewModel)
            } detail: {
                TabContentViewIPadOS(windowViewModel: windowViewModel, webView: webView)
            }
        }
        .overlay(alignment: .center) {
            AddBookmarkAlert
        }
    }

    private var AddBookmarkAlert: some View {
        Group {
            if windowViewModel.showAddBookmark {
                AddBookmarkIPadOS(
                    viewModel: windowViewModel,
                    bookmarkName: windowViewModel.title,
                    bookmarkURL: windowViewModel.fullURL
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(windowViewModel.showAddBookmark ? Color.black.opacity(0.3) : Color.clear)
    }
}
#endif
