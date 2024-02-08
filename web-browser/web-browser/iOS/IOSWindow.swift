import SwiftUI

struct IOSWindow: View {
    @ObservedObject var viewModel: ViewModel
    let webView: AnyView

    var body: some View {
        VStack {
            BrowserTextField(viewModel: viewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                BrowserNavigationButtons(viewModel: viewModel)
                Spacer()
            }
            .padding()
        }
    }
}

