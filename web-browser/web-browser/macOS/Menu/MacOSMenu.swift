import SwiftUI

#if os(macOS)
struct MacOSMenu: View {
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        List {
            NavigationLink(destination: MacOSHistoryView(viewModel: historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
