import SwiftUI

#if os(iOS)
struct BookmarkIPadOS: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteBookmarkAlert = false

    var body: some View {
        VStack {
            if isBookmarkEmpty() {
                EmptyView
            } else {
                BookmarkList
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")       
        .onAppear(perform: viewModel.delegate?.didOpenBookmarkView)
    }

    private var BookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
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
        .alert(isPresented: $isShowingDeleteBookmarkAlert) { alertView }
    }

    private var alertView: Alert {
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
