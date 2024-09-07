import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        NavigationSplitView {
            MacOSMenu(menuViewModel: menuViewModel)
        } detail: {
            VStack {
                HStack {
                    WindowNavigationButtons(viewModel: windowViewModel)
                    AddressBarView(viewModel: windowViewModel)                   
                }
                Spacer()
                webView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
    }
}
