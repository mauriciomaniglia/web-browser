import SwiftUI

#if os(visionOS)
struct VisionOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly

    let webView: AnyView

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            MacOSMenu(menuViewModel: menuViewModel)
        } detail: {
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.top),
            contentAlignment: .center
        ) {
            HStack {
                Spacer()
                Button(action: toggleNavigationSplitVisibility) {
                    Image(systemName: "sidebar.left")
                }
                Spacer(minLength: 20)
                WindowNavigationButtons(viewModel: windowViewModel)
                AddressBarView(viewModel: windowViewModel)
            }
            .frame(width: 1000)
            .padding()
            .glassBackgroundEffect()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        }
    }

    private func toggleNavigationSplitVisibility() {
        if columnVisibility == .detailOnly {
            columnVisibility = .all
        } else {
            columnVisibility = .detailOnly
        }
    }
}
#endif
