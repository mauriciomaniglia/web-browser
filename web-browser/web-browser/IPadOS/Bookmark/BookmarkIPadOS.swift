import SwiftUI

#if os(iOS)
struct BookmarkIPadOS: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteBookmarkAlert = false

    var body: some View {
        SearchTopBar
            .onAppear {
                viewModel.didOpenBookmarkView?()
            }

        if isBookmarkEmpty() {
            EmptyView
        } else {
            BookmarkList
        }
    }

    private var SearchTopBar: some View {
        HStack {
            TextField("Search Bookmark", text: $searchText)
                .onChange(of: searchText, { _, newValue in
                    viewModel.didSearchTerm?(newValue)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }

    private var BookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                HStack {
                    Text(bookmark.title)
                        .onTapGesture {
                            viewModel.didSelectPage?(bookmark.url)
                            dismiss()
                        }
                    Spacer()
                    Button {
                        viewModel.setSelectedBookmark(bookmark)
                        isShowingDeleteBookmarkAlert = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                .padding()
            }
        }
        .alert(isPresented: $isShowingDeleteBookmarkAlert) {
            Alert(
                title: Text("Remove?"),
                primaryButton: .default(Text("Yes")) {
                    viewModel.removeSelectedBookmark()
                },
                secondaryButton: .cancel() {
                    viewModel.undoCurrentSelection()
                }
            )
        }
    }

    private var EmptyView: some View {
        VStack {
            Text("No bookmark found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    private func isBookmarkEmpty() -> Bool {
        viewModel.bookmarkList.isEmpty
    }
}
#endif
