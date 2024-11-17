import SwiftUI

#if os(iOS)
struct WindowIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuIPadOS(windowViewModel: windowViewModel)
            } detail: {
                VStack {
                    webView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        WindowNavigationButtons(viewModel: windowViewModel)
                    }
                    ToolbarItem(placement: .principal) {
                        AddressBarView(viewModel: windowViewModel)
                    }
                }
            }
        }
    }
}
#endif
