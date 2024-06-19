import SwiftUI

struct MacOSWindow: View {
    @ObservedObject var viewModel: WindowViewModel
    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                if viewModel.showMenuButton {
                    Button(action: {}) {
                        Image(systemName: "sidebar.left")
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.gray)
                }
                WindowNavigationButtons(viewModel: viewModel)
                AddressBarView(viewModel: viewModel)
                Spacer()
            }
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
