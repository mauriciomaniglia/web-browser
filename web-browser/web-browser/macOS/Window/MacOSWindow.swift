import SwiftUI

#if os(macOS)
struct MacOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    let webView: AnyView

    var body: some View {
        NavigationSplitView {
            MacOSMenu(historyViewModel: historyViewModel)
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
