import SwiftUI

struct VisionOSMenu: View {
    @ObservedObject var historyViewModel: HistoryViewModel

    var body: some View {
        List {
            NavigationLink(destination: HistoryView(viewModel: historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
