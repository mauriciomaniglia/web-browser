import SwiftUI

struct Bookmark: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAlert = false

    // MARK: - Body

    var body: some View {
        VStack {
            backButton

            if isBookmarkEmpty {
                emptyList
            } else {
                bookmarkList
            }
        }
        .navigationTitle("Bookmark")
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")
        .onAppear(perform: viewModel.delegate?.didOpenBookmarkView)
    }

    // MARK: - Buttons

    var backButton: some View {
        HStack {
            Button { dismiss() } label: { Image(systemName: "arrow.left") }
            Spacer()
        }
        .padding()
    }

    // MARK: - List

    var isBookmarkEmpty: Bool {
        viewModel.bookmarkList.isEmpty
    }

    var bookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                BookmarkRow(
                    viewModel: viewModel,
                    isShowingDeleteBookmarkAlert: $isShowingDeleteAlert,
                    bookmark: bookmark
                )
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

    // MARK: - Alert

    var removeItemAlert: Alert {
        Alert(
            title: Text("Remove?"),
            primaryButton: .default(Text("Yes")) { viewModel.removeSelectedBookmark() },
            secondaryButton: .cancel() { viewModel.undoCurrentSelection() }
        )
    }
}

struct BookmarkRow: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowingDeleteBookmarkAlert: Bool
    let bookmark: BookmarkViewModel.Bookmark

    var body: some View {
        HStack {
            Text(bookmark.title)
                .onTapGesture {
                    viewModel.delegate?.didSelectPage(bookmark.url)
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
