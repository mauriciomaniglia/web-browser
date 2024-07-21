import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
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
