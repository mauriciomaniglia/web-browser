import SwiftUI

struct BookmarkView: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Binding var isShowingBookmarks: Bool
    @State private var searchText: String = ""
    @State private var isShowingDeleteBookmarkAlert = false

    var body: some View {
        VStack {
            header
            if isBookmarkEmpty {
                emptyList
            } else {
                bookmarkList
            }
        }
        .padding()
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")
        .onAppear(perform: viewModel.delegate?.didOpenBookmarkView)
        .frame(maxWidth: 500, maxHeight: 500)
        .background(Color(UIColor.systemGroupedBackground))
    }

    var header: some View {
        HStack {
            Spacer()
            title
            Spacer()
            closeButton
        }
    }

    var title: some View {
        Text("Bookmarks")
            .font(.title2)
            .bold()
    }

    var closeButton: some View {
        Button(action: {
            isShowingBookmarks.toggle()
        }) {
            Text("Done")
        }
    }

    var isBookmarkEmpty: Bool {
        viewModel.bookmarkList.isEmpty
    }

    var bookmarkList: some View {
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                HStack {
                    Text(bookmark.title)
                        .onTapGesture {
                            viewModel.delegate?.didSelectPage(bookmark.url)
                            isShowingBookmarks.toggle()
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

    var emptyList: some View {
        VStack {
            Text("No bookmark found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    var alertView: Alert {
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
