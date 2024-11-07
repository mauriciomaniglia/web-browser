import SwiftUI

struct MacOSAddBookmarkView: View {
    @ObservedObject var viewModel: WindowViewModel
    @Binding var isPresented: Bool
    @State var bookmarkName = ""
    @State var bookmarkURL = ""
    let backgroundColor: Color

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
                    isPresented = false
                }

                Spacer()

                Button("Done") {
                    viewModel.bookmarkViewModel.didTapAddBookmark?(bookmarkName, bookmarkURL)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 20)
        .frame(maxWidth: 300)
    }
}
