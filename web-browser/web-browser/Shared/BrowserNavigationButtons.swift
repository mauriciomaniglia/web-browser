import SwiftUI

struct BrowserNavigationButtons: View {
    @Binding var isBackButtonDisabled: Bool
    @Binding var isBackForwarDisabled: Bool

    var onBackButtonPressed: (() -> Void)?
    var onForwardButtonPressed: (() -> Void)?

    var body: some View {
        HStack(spacing: 20) {
            Button(action: { onBackButtonPressed?() }) {
                Image(systemName: "arrow.left")
            }
            .disabled(isBackButtonDisabled)

            Button(action: { onForwardButtonPressed?() }) {
                Image(systemName: "arrow.right")
            }
            .disabled(isBackForwarDisabled)
        }
    }
}
