import SwiftUI

struct AddBookmarkView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    @State var bookmarkName: String
    @State var bookmarkURL: String

    var body: some View {
        VStack(spacing: 20) {
            header
            form
            Spacer()
        }
        .padding()
        .frame(maxWidth: 400, maxHeight: 400)
        .background(Color(UIColor.systemBackground))
    }

    var header: some View {
        HStack {
            closeButton
            Spacer()
            title
            Spacer()
            saveButton
        }
    }

    var closeButton: some View {
        Button(action: tabViewModel.dismissAddBookmark) {
            Image(systemName: "xmark")
        }
    }

    var title: some View {
        Text("Add Bookmark")
            .font(.title2)
            .bold()
    }

    var saveButton: some View {
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

    var form: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                TextField("Title", text: $bookmarkName)
                    .textFieldStyle(.roundedBorder)
                TextField("URL", text: $bookmarkURL)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
        }
    }
}
