import SwiftUI

struct AddBookmarkVisionOS: View {
    @ObservedObject var viewModel: WindowViewModel

    @State var bookmarkName: String
    @State var bookmarkURL: String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: viewModel.dismissAddBookmark) {
                    Image(systemName: "xmark")
                }
                Spacer()
                Text("Add Bookmark")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    viewModel.saveAndDismissAddBookmark(
                        name: bookmarkName,
                        url: bookmarkURL
                    )
                }) {
                    Text("Save")
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Title", text: $bookmarkName)
                        .textFieldStyle(.roundedBorder)
                    TextField("URL", text: $bookmarkURL)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: 400, maxHeight: 400)
        .background(.ultraThinMaterial)
        .background(Color.black.opacity(0.6))
    }
}
