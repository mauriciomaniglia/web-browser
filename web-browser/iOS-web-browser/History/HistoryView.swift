import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Binding var isPresented: Bool
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        VStack {
            searchBar

            if isHistoryEmpty {
                emptyList
            } else {
                historyList
            }
        }
        .onAppear {
            viewModel.delegate?.didOpenHistoryView()
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem {
                clearAllButton
            }
        }
        .alert(isPresented: $isShowingDeleteAllHistoryAlert) {
            clearAllAlert
        }
    }

    var searchBar: some View {
        HStack {
            TextField("Search History", text: $searchText)
                .onChange(of: searchText, { _, newValue in
                    viewModel.delegate?.didSearchTerm(newValue)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }

    var isHistoryEmpty: Bool {
        viewModel.historyList.isEmpty
    }

    var historyList: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { index in
                let item = viewModel.historyList[index]

                let header = Text(item.title)

                Section(header: header) {
                    ForEach(item.pages) { page in
                        Text("\(page.title)")
                            .onTapGesture {
                                viewModel.delegate?.didSelectPage(page.url)
                                isPresented = false
                            }
                    }
                    .onDelete { offsets in
                        viewModel.deletePages(at: offsets, inSection: index)
                    }
                }
            }
        }
    }

    var emptyList: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    var clearAllButton: some View {
        Button {
            isShowingDeleteAllHistoryAlert = true
        } label: {
            Image(systemName: "trash")
        }
    }

    var clearAllAlert: Alert {
        Alert(
            title: Text("Clear all browsing history?"),
            primaryButton: .default(Text("Clear")) {
                viewModel.deleteAllPages()
            },
            secondaryButton: .cancel()
        )
    }
}
