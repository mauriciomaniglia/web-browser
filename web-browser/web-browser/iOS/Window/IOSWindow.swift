import SwiftUI

struct IOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: viewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: viewModel)
                Spacer()
                if viewModel.showMenuButton {
                    Button(action: { menuViewModel.didTapMenuButton?() }) {
                        Image(systemName: "line.3.horizontal")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                    .popover(isPresented: $menuViewModel.showMenu, arrowEdge: .trailing, content: {
                        MenuView(viewModel: menuViewModel)
                    })
                    .popover(isPresented: $menuViewModel.showHistory, content: {
                        HistoryView(historyList: menuViewModel.historyList)
                    })
                }
            }
            .padding()
        }
    }
}

