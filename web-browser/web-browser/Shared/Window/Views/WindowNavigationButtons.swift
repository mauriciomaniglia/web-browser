import SwiftUI

struct WindowNavigationButtons: View {
    @ObservedObject var viewModel: WindowViewModel

    var body: some View {
        HStack(spacing: 20) {
            Button(action: { viewModel.didTapBackButton?() }) {
                Image(systemName: "arrow.left")
            }
            .disabled(viewModel.isBackButtonDisabled)
            .onLongPressGesture {
                viewModel.didLongPressBackButton?()
            }

            Button(action: { viewModel.didTapForwardButton?() }) {
                Image(systemName: "arrow.right")
            }
            .disabled(viewModel.isForwardButtonDisabled)
            .onLongPressGesture {
                viewModel.didLongPressForwardButton?()
            }
        }
    }
}
