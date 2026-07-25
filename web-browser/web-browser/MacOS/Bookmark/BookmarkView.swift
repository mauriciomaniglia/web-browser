import SwiftUI
import Services

struct BookmarkView: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAlert = false

    var body: some View {
        VStack {
            if isBookmarkEmpty {
                emptyList
            } else {
                bookmarkList
            }
        }
        .navigationTitle("Bookmark")
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")
        .task {
            viewModel.didOpenBookmarkView()
        }
    }

    var isBookmarkEmpty: Bool {
        viewModel.bookmarkList.isEmpty
    }

    var bookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                bookmarkRow(bookmark)
            }
        }
        .alert(isPresented: $isShowingDeleteAlert) { removeItemAlert }
    }

    var emptyList: some View {
        VStack {
            Text("No bookmark found.")
                .font(.headline)
                .padding()

            Spacer()
        }
    }

    var removeItemAlert: Alert {
        Alert(
            title: Text("Remove?"),
            primaryButton: .default(Text("Yes")) { viewModel.removeSelectedBookmark() },
            secondaryButton: .cancel() { viewModel.undoCurrentSelection() }
        )
    }

    func bookmarkRow(_ bookmark: BookmarkViewData) -> some View {
        HStack {
            Text(bookmark.title)
                .onTapGesture {
                    viewModel.didSelectPage(bookmark.url)
                    dismiss()
                }
            Spacer()
            Button {
                viewModel.setSelectedBookmark(bookmark)
                isShowingDeleteAlert = true
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
    }
}
