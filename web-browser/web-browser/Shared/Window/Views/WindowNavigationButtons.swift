import SwiftUI

struct WindowNavigationButtons: View {
    @ObservedObject var viewModel: WindowViewModel

    var body: some View {
        HStack(spacing: 20) {
            CustomGestureButton(imageName: "arrow.left",
                                action: { viewModel.didTapBackButton?() },
                                longPressAction: { viewModel.didLongPressBackButton?() }, 
                                isDisabled: viewModel.isBackButtonDisabled)
            .popover(isPresented: $viewModel.showBackList, arrowEdge: .bottom, content: {
                NavigationHistoryView(didSelectPage: viewModel.didSelectBackListPage, pageList: viewModel.backList)
            })
            .onChange(of: viewModel.showBackList) { _, isPresented in
                if !isPresented {
                    viewModel.didDismissBackForwardPageList?()
                }
            }

            CustomGestureButton(imageName: "arrow.right",
                                action: { viewModel.didTapForwardButton?() },
                                longPressAction: { viewModel.didLongPressForwardButton?() }, 
                                isDisabled: viewModel.isForwardButtonDisabled)
            .popover(isPresented: $viewModel.showForwardList, arrowEdge: .bottom, content: {
                NavigationHistoryView(didSelectPage: viewModel.didSelectForwardListPage, pageList: viewModel.forwardList)
            })
            .onChange(of: viewModel.showForwardList) { _, isPresented in
                if !isPresented {
                    viewModel.didDismissBackForwardPageList?()
                }
            }
        }
    }
}
