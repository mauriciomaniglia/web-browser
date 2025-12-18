import SwiftUI

struct Window: View {
    let windowComposer: WindowComposer

    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        ZStack {
            NavigationSplitView {
                Menu(bookmarkViewModel: bookmarkViewModel,historyViewModel: historyViewModel)
            } detail: {
                TabBarViewControllerWrapper(windowComposer: windowComposer)
            }
        }
    }
}
