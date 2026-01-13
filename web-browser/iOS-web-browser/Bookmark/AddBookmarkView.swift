import SwiftUI

struct AddBookmarkView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    @State var bookmarkName: String
    @State var bookmarkURL: String

    @FocusState private var isNameFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                form
                Spacer()
            }
            .padding()
            .navigationTitle("Add Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .onAppear {
                isNameFieldFocused = true
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    var cancelButton: some View {
        Button("Cancel", action: {
            tabViewModel.dismissAddBookmark()
        })
    }

    var saveButton: some View {
        Button("Save", action: {
            tabViewModel.saveAndDismissAddBookmark(
                name: bookmarkName,
                url: bookmarkURL
            )
            bookmarkViewModel.delegate?.didTapAddBookmark(name: bookmarkName, urlString: bookmarkURL)
        })
    }

    var form: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Name", text: $bookmarkName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isNameFieldFocused)
                TextField("URL", text: $bookmarkURL)
                    .disabled(true)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.URL)
            }
        }
    }
}
