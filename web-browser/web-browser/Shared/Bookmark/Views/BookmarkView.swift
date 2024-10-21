import SwiftUI

struct BookmarkView: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var body: some View {
        SearchTopBar
            .navigationTitle("Bookmark")
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
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
            }
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
                Text(bookmark.title)
                    .onTapGesture {
                        viewModel.didSelectPage?(bookmark.url.absoluteString)
                        dismiss()
                    }
                    .onHover { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
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
