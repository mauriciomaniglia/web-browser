import SwiftUI

#if os(iOS)
struct AddBookmarkIOS: View {
    @ObservedObject var viewModel: TabViewModel
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
                    viewModel.dismissAddBookmark()
                }),
                trailing: Button("Save", action: {
                    viewModel.saveAndDismissAddBookmark(
                        name: bookmarkName,
                        url: bookmarkURL
                    )
                })
            )
            .onAppear {
                isNameFieldFocused = true
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
#endif
