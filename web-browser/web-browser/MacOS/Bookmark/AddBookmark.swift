import SwiftUI

#if os(macOS)
struct AddBookmark: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @Binding var isPresented: Bool
    @State var bookmarkName = ""
    @State var bookmarkURL = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Bookmark added")
                .font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                TextField("Name", text: $bookmarkName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("URL", text: $bookmarkURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(true)
            }
            HStack {
                Button("Remove") {
                    tabViewModel.dismissAddBookmark()
                }
                Spacer()
                Button("Done") {
                    tabViewModel.saveAndDismissAddBookmark(
                        name: bookmarkName,
                        url: bookmarkURL
                    )
                    bookmarkViewModel.delegate?.didTapAddBookmark(name: bookmarkName, urlString: bookmarkURL)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
        .frame(maxWidth: 300)
    }
}
#endif
