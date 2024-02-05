import SwiftUI

struct IOSWindow: View {
    @ObservedObject var viewModel: ViewModel

    var onEnterPressed: ((String) -> Void)?
    var onBackButtonPressed: (() -> Void)?
    var onForwardButtonPressed: (() -> Void)?

    let webView: AnyView

    var body: some View {
        VStack {
            BrowserTextField(
                progress: $viewModel.progressBarValue, 
                onEnterPressed: onEnterPressed
            )
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                BrowserNavigationButtons(
                    isBackButtonDisabled: $viewModel.isBackButtonDisabled,
                    isBackForwarDisabled: $viewModel.isForwardButtonDisabled,
                    onBackButtonPressed: onBackButtonPressed,
                    onForwardButtonPressed: onForwardButtonPressed
                )
                Spacer()
            }
            .padding()
        }
    }
}

