import SwiftUI

struct MacOSMenu: View {
    @ObservedObject var menuViewModel: MenuViewModel

    var body: some View {
        List {
            NavigationLink(destination: HistoryView(viewModel: menuViewModel.historyViewModel)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
