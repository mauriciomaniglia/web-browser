import SwiftUI

#if os(iOS)
struct BookmarkIOS: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            if isBookmarkEmpty() {
                EmptyView
            } else {
                BookmarkList
            }

        }
        .navigationTitle("Bookmark")
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")
        .onAppear(perform: viewModel.delegate?.didOpenBookmarkView)
    }

    private var BookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                Text(bookmark.title)
                    .onTapGesture {
                        viewModel.delegate?.didSelectPage(bookmark.url)
                        isPresented = false
                    }
            }
            .onDelete { offsets in
                viewModel.deleteBookmarks(at: offsets)
            }
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
