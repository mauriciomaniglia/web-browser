import SwiftUI

struct IOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: windowViewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)
                Spacer()
                if windowViewModel.showMenuButton {
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
            .padding()
        }
    }
}

