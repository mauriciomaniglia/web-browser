import SwiftUI

#if os(iOS)
struct IOSMenuView: View {
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: HistoryView(viewModel: historyViewModel)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
    }
}
#endif
