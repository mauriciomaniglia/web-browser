import SwiftUI

struct MenuButton: View {
    @ObservedObject var menuViewModel: MenuViewModel

    var body: some View {
        Button(action: { menuViewModel.didTapMenuButton?() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.primary)
        .popover(isPresented: $menuViewModel.showMenu, arrowEdge: .trailing, content: {
            MenuView(viewModel: menuViewModel)
        })
        .popover(isPresented: $menuViewModel.showHistory, content: {            
            HistoryView(viewModel: menuViewModel.historyViewModel)
        })
    }
}
