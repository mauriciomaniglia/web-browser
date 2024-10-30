import SwiftUI

struct IOSBookmarkView: View {
    @ObservedObject var viewModel: BookmarkViewModel
    @Binding var isPresented: Bool
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
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
                Text(bookmark.title)
                    .onTapGesture {
                        viewModel.didSelectPage?(bookmark.url.absoluteString)
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
