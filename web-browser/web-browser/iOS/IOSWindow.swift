import SwiftUI

struct IOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: viewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: viewModel)
                Spacer()
            }
            .padding()
        }
    }
}

