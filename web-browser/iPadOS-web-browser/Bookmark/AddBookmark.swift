import SwiftUI

struct AddBookmark: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    @State var bookmarkName: String
    @State var bookmarkURL: String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: tabViewModel.dismissAddBookmark) {
                    Image(systemName: "xmark")
                }
                Spacer()
                Text("Add Bookmark")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    tabViewModel.saveAndDismissAddBookmark(
                        name: bookmarkName,
                        url: bookmarkURL
                    )
                    bookmarkViewModel.delegate?.didTapAddBookmark(name: bookmarkName, urlString: bookmarkURL)
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
        .background(Color(UIColor.systemBackground))
    }
}
