import SwiftUI

struct AddBookmark: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @State var bookmarkName: String
    @State var bookmarkURL: String

    @FocusState private var isNameFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
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
                Spacer()
            }
            .padding()
            .navigationTitle("Add Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel", action: {
                    tabViewModel.dismissAddBookmark()
                }),
                trailing: Button("Save", action: {
                    tabViewModel.saveAndDismissAddBookmark(
                        name: bookmarkName,
                        url: bookmarkURL
                    )
                    bookmarkViewModel.delegate?.didTapAddBookmark(name: bookmarkName, urlString: bookmarkURL)
                })
            )
            .onAppear {
                isNameFieldFocused = true
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
