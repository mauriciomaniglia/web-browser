import SwiftUI

struct WindowNavigationButtons: View {
    @ObservedObject var viewModel: WindowViewModel

    var body: some View {
        HStack(spacing: 20) {
            CustomGestureButton(imageName: "arrow.left",
                                action: { viewModel.didTapBackButton?() },
                                longPressAction: { viewModel.didLongPressBackButton?() }, 
                                isDisabled: viewModel.isBackButtonDisabled)

            CustomGestureButton(imageName: "arrow.right",
                                action: { viewModel.didTapForwardButton?() },
                                longPressAction: { viewModel.didLongPressForwardButton?() }, 
                                isDisabled: viewModel.isForwardButtonDisabled)
        }
    }
}
