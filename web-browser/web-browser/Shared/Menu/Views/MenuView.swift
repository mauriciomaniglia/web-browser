import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.historyViewModel.didOpenHistoryView?()
                viewModel.didTapHistoryOption?()
            }
        }
        .padding()
        .presentationCompactAdaptation((.popover))
    }
}
