import SwiftUI

#if os(macOS)
struct MacAddBookmarkView: View {
    @ObservedObject var viewModel: WindowViewModel
    @Binding var isPresented: Bool
    @State var name = ""

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
                    isPresented = false
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
