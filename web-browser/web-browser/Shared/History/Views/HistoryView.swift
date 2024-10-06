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

        if isHistoryEmpty() {
            EmptyView
        } else {
            HistoryList
        }
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
                    .onDelete { offsets in
                        viewModel.deletePages(at: offsets, inSection: index)
                    }
                }
            }
        }
    }

    private var EmptyView: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    private func isHistoryEmpty() -> Bool {
        viewModel.historyList.isEmpty
    }
}
