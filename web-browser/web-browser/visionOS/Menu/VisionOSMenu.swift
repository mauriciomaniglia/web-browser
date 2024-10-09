import SwiftUI

#if os(visionOS)
struct VisionOSMenu: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @Binding var isPresented: Bool

    var body: some View {
        List {
            NavigationLink(destination: HistoryView(viewModel: historyViewModel, isPresented: $isPresented)) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
#endif
