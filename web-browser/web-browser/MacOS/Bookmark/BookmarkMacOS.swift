import SwiftUI

struct BookmarkMacOS: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteBookmarkAlert = false

    var body: some View {
        SearchTopBar
            .navigationTitle("Bookmark")
            .onAppear(perform: viewModel.didOpenBookmarkView)

        if viewModel.bookmarkList.isEmpty {
            EmptyView
        } else {
            BookmarkListView
        }
    }

    private var SearchTopBar: some View {
        HStack {
            Button { dismiss() } label: { Image(systemName: "arrow.left") }

            TextField("Search Bookmark", text: $searchText)
                .onChange(of: searchText, { _, newValue in viewModel.didSearchTerm?(newValue) })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }

    private var BookmarkListView: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                ListItem(
                    viewModel: viewModel,
                    isShowingDeleteBookmarkAlert: $isShowingDeleteBookmarkAlert,
                    bookmark: bookmark
                )
            }
        }
        .alert(isPresented: $isShowingDeleteBookmarkAlert) { RemoveItemAlert }
    }

    private var EmptyView: some View {
        VStack {
            Text("No bookmark found.")
                .font(.headline)
                .padding()

            Spacer()
        }
    }

    private var RemoveItemAlert: Alert {
        Alert(
            title: Text("Remove?"),
            primaryButton: .default(Text("Yes")) { viewModel.removeSelectedBookmark() },
            secondaryButton: .cancel() { viewModel.undoCurrentSelection() }
        )
    }

    struct ListItem: View {
        @ObservedObject var viewModel: BookmarkViewModel
        @Environment(\.dismiss) private var dismiss
        @Binding var isShowingDeleteBookmarkAlert: Bool
        let bookmark: BookmarkViewModel.Bookmark

        var body: some View {
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
}
