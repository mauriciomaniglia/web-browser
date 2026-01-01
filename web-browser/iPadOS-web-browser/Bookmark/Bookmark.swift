import SwiftUI

struct Bookmark: View {
    @ObservedObject var viewModel: BookmarkViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = ""
    @State private var isShowingDeleteBookmarkAlert = false

    // MARK: - Body

    var body: some View {
        VStack {
            if isBookmarkEmpty {
                emptyList
            } else {
                bookmarkList
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Bookmark")       
        .onAppear(perform: viewModel.delegate?.didOpenBookmarkView)
    }

    // MARK: - List

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

    var emptyList: some View {
        VStack {
            Text("No bookmark found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    // MARK: - Alerts

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
