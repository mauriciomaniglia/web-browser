import SwiftUI

struct VisionOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                BrowserNavigationButtons(viewModel: viewModel)
                BrowserTextField(viewModel: viewModel)
                Spacer()
            }
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
