import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var viewModel: ViewModel

    var onEnterPressed: ((String) -> Void)?
    var onBackButtonPressed: (() -> Void)?
    var onForwardButtonPressed: (() -> Void)?

    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                BrowserNavigationButtons(
                    isBackButtonDisabled: $viewModel.isBackButtonDisabled,
                    isBackForwarDisabled: $viewModel.isForwardButtonDisabled,
                    onBackButtonPressed: onBackButtonPressed,
                    onForwardButtonPressed: onForwardButtonPressed
                )
                BrowserTextField(
                    progress: $viewModel.progressBarValue,
                    onEnterPressed: onEnterPressed
                )
                Spacer()
            }
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
