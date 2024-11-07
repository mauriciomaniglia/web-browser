import SwiftUI

struct VisionOSAddBookmarkView: View {
    @ObservedObject var viewModel: WindowViewModel
    @State var bookmarkName: String
    @State var bookmarkURL: String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { viewModel.showAddBookmark = false }) {
                    Image(systemName: "xmark")
                }

                Spacer()

                Text("Add Bookmark")
                    .font(.title2)
                    .bold()

                Spacer()

                Button(action: {
                    viewModel.showAddBookmark = false
                    viewModel.bookmarkViewModel.didTapAddBookmark?(bookmarkName, bookmarkURL)
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
