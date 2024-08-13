import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        NavigationSplitView {
            Sidebar()
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
    var body: some View {
        List {
            NavigationLink(value: "History") {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }
}
