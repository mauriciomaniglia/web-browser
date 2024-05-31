import SwiftUI

struct VisionOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                WindowNavigationButtons(viewModel: viewModel)
                AddressBarView(viewModel: viewModel)
                Spacer()
            }
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
