import SwiftUI

struct AddBookmarkView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @Binding var isPresented: Bool
    @State var bookmarkName = ""
    @State var bookmarkURL = ""

    var body: some View {
        VStack(spacing: 20) {
            header
            form
            footer
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
        .frame(maxWidth: 300)
    }

    var header: some View {
        Text("Bookmark added")
            .font(.headline)
    }

    var form: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Name", text: $bookmarkName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("URL", text: $bookmarkURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disabled(true)
        }
    }

    var footer: some View {
        HStack {
            dismissButton
            Spacer()
            doneButton
        }
        .padding(.horizontal)
    }

    var dismissButton: some View {
        Button("Remove") {
            tabViewModel.dismissAddBookmark()
        }
    }

    var doneButton: some View {
        Button("Done") {
            tabViewModel.saveAndDismissAddBookmark(name: bookmarkName, url: bookmarkURL)
            bookmarkViewModel.delegate?.didTapAddBookmark(name: bookmarkName, urlString: bookmarkURL)
        }
        .buttonStyle(.borderedProminent)
    }
}
