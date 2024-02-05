import SwiftUI

struct BrowserTextField: View {
    @State var text = ""
    @Binding var progress: Double?

    var onEnterPressed: ((String) -> Void)?

    var body: some View {
        VStack {
            TextField("Search or enter address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    onEnterPressed?(text)
                }
            if (progress != nil) {
                ProgressView(value: progress, total: 1.0)
                    .padding(EdgeInsets(top: -28, leading: 15, bottom: 0, trailing: 15))
            }
        }
    }
}
