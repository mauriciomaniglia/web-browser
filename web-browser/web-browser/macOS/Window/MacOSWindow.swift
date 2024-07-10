import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                WindowNavigationButtons(viewModel: viewModel)
                AddressBarView(viewModel: viewModel)
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
                        HistoryView(didSelectPage: menuViewModel.didSelectPageHistory, pages: menuViewModel.historyList)
                    })
                }
            }
            Spacer()
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
