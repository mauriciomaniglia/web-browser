import SwiftUI

struct NavigationBar: View {
    @ObservedObject var viewModel: TabViewModel

    var body: some View {
        HStack(spacing: 20) {
            backButton
            forwardButton
        }
    }

    var backButton: some View {
        CustomGestureButton(imageName: "arrow.left",
                            action: { viewModel.didTapBackButton?() },
                            longPressAction: { viewModel.didLongPressBackButton?() },
                            isDisabled: viewModel.isBackButtonDisabled)
        .popover(isPresented: $viewModel.showBackList, content: {
            NavigationList(didSelectPage: viewModel.didSelectBackListPage, pageList: viewModel.backList)
                .presentationCompactAdaptation(.popover)
        })
        .onChange(of: viewModel.showBackList) { _, isPresented in
            if !isPresented {
                viewModel.didDismissBackForwardPageList?()
            }
        }
    }

    var forwardButton: some View {
        CustomGestureButton(imageName: "arrow.right",
                            action: { viewModel.didTapForwardButton?() },
                            longPressAction: { viewModel.didLongPressForwardButton?() },
                            isDisabled: viewModel.isForwardButtonDisabled)
        .popover(isPresented: $viewModel.showForwardList, content: {
            NavigationList(didSelectPage: viewModel.didSelectForwardListPage, pageList: viewModel.forwardList)
                .presentationCompactAdaptation(.popover)
        })
        .onChange(of: viewModel.showForwardList) { _, isPresented in
            if !isPresented {
                viewModel.didDismissBackForwardPageList?()
            }
        }
    }
}
