import SwiftUI

struct BrowserTextField: View {
    @ObservedObject var viewModel: WindowViewModel
    @State var text = ""

    var body: some View {
        VStack {
            TextField("Search or enter address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    viewModel.didStartSearch?(text)
                }
            if (viewModel.progressBarValue != nil) {
                ProgressView(value: viewModel.progressBarValue, total: 1.0)
                    .padding(EdgeInsets(top: -28, leading: 15, bottom: 0, trailing: 15))
            }
        }
    }
}
