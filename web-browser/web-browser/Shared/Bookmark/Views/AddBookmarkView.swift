import SwiftUI

struct AddBookmarkView: View {
    @ObservedObject var viewModel: WindowViewModel
    @Binding var isPresented: Bool
    @State var name = ""
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 20) {
            Text("Bookmark added")
                .font(.headline)

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack {
                Button("Remove") {
                    isPresented = false
                }

                Spacer()

                Button("Done") {
                    viewModel.bookmarkViewModel.didTapAddBookmark?()
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
