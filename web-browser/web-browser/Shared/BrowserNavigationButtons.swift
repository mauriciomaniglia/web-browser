import SwiftUI

struct BrowserNavigationButtons: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 20) {
            Button(action: { viewModel.didTapBackButton?() }) {
                Image(systemName: "arrow.left")
            }
            .disabled(viewModel.isBackButtonDisabled)

            Button(action: { viewModel.didTapForwardButton?() }) {
                Image(systemName: "arrow.right")
            }
            .disabled(viewModel.isForwardButtonDisabled)
        }
    }
}
