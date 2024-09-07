import SwiftUI

struct IOSMenuButton: View {
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        Button(action: { viewModel.didTapMenuButton?() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.primary)
        .popover(isPresented: $viewModel.showMenu, arrowEdge: .trailing, content: {
            IOSMenuView(viewModel: viewModel)
        })
        .popover(isPresented: $viewModel.showHistory, content: {
            HistoryView(viewModel: viewModel.historyViewModel)
        })
    }
}
