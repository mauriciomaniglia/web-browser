import SwiftUI

#if os(iOS)
struct IOSMenuView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: IOSHistoryView(viewModel: historyViewModel, isPresented: $isPresented)) {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
        }
    }
}
#endif
