import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        SearchTopBar
            .navigationTitle("History")
            .onAppear {
                viewModel.didOpenHistoryView?()
            }
        HistoryList
    }

    private var SearchTopBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
            }

            TextField("Search History", text: $searchText)
                .onChange(of: searchText, { _, newValue in
                    viewModel.didSearchTerm?(newValue)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button {
                isShowingDeleteAllHistoryAlert = true
            } label: {
                Image(systemName: "trash")
            }
            .alert(isPresented: $isShowingDeleteAllHistoryAlert) {
                Alert(
                    title: Text("Clear all browsing history?"),
                    primaryButton: .default(Text("Clear")) {
                        viewModel.deleteAllPages()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
    }

    private var HistoryList: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { index in
                let item = viewModel.historyList[index]

                let header = Text(item.title)

                Section(header: header) {
                    ForEach(item.pages) { page in
                        Text("\(page.title)")
                            .onTapGesture {
                                viewModel.didSelectPage?(page.url)
                                dismiss()
                            }
                    }
                    .onDelete(perform: delete)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {

    }
}
