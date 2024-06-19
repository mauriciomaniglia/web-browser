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
                if viewModel.showMenuButton {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                }
            }
            .padding()
        }
    }
}

