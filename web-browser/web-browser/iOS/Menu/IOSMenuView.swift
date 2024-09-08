import SwiftUI

struct IOSMenuView: View {
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: HistoryView(viewModel: viewModel.historyViewModel)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
    }
}
