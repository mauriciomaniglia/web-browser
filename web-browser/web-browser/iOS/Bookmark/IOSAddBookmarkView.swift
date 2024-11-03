import SwiftUI

#if os(iOS)
struct IOSAddBookmarkView: View {
    @ObservedObject var viewModel: WindowViewModel
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
                    viewModel.showAddBookmark = false
                }),
                trailing: Button("Save", action: {
                    viewModel.showAddBookmark = false
                    viewModel.bookmarkViewModel.didTapAddBookmark?()
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
