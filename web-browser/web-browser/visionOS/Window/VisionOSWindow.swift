import SwiftUI

#if os(visionOS)
struct VisionOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var menuViewModel: MenuViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.top),
            contentAlignment: .center
        ) {
            HStack {
                Spacer()
                WindowNavigationButtons(viewModel: windowViewModel)
                AddressBarView(viewModel: windowViewModel)
            }
            .frame(width: 1000)
            .padding()
            .glassBackgroundEffect()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        }
    }
}
#endif
