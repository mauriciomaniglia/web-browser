import SwiftUI

#if os(macOS)
struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        NavigationSplitView {
            MacOSMenu(windowViewModel: windowViewModel)
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
#endif
