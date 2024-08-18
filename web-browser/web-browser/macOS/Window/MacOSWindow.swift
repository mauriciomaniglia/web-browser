import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        NavigationSplitView {
            Sidebar(menuViewModel: menuViewModel)
        } detail: {
            VStack {
                HStack {
                    WindowNavigationButtons(viewModel: windowViewModel)
                    AddressBarView(viewModel: windowViewModel)
                    Spacer()
                    if windowViewModel.showMenuButton {
                        MenuButton(viewModel: menuViewModel)
                    }
                }
                Spacer()
                webView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
    }
}

struct Sidebar: View {
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
