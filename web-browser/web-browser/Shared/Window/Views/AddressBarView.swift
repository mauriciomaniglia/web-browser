import SwiftUI

struct AddressBarView: View {
    @ObservedObject var viewModel: WindowViewModel

    @State private var text = ""
    @State private var isShowingSheet = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    if viewModel.showSiteProtection {
                        WebsiteProtectionButton(viewModel: viewModel, isShowingSheet: isShowingSheet)
                    }

                    TextField("Search or enter address", text: $text)
                        .textFieldStyle(.plain)
                        .onSubmit { viewModel.didStartSearch?(text) }

                    if viewModel.showStopButton {
                        Button(action: { print("Cancel") }) {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding(.horizontal)

            if (viewModel.progressBarValue != nil) {
                ProgressView(value: viewModel.progressBarValue, total: 1.0)
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
            }
        }
    }
}
