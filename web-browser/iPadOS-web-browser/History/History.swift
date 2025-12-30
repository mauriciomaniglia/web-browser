import SwiftUI

struct History: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    // MARK: Body

    var body: some View {
        searchBar

        if isHistoryEmpty {
            emptyList
        } else {
            historyList
        }
    }

    // MARK: Search Bar

    var searchBar: some View {
        HStack {
            searchTextField
            clearAllHistoryButton
        }
        .padding()
        .navigationTitle("History")
        .onAppear(perform: viewModel.delegate?.didOpenHistoryView)
        .alert(isPresented: $isShowingDeleteAllHistoryAlert) {
            clearAllHistoryAlert
        }
    }

    var searchTextField: some View {
        TextField("Search History", text: $searchText)
            .onChange(of: searchText, { _, newValue in
                viewModel.delegate?.didSearchTerm(newValue)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }

    var clearAllHistoryAlert: Alert {
        Alert(
            title: Text("Clear all browsing history?"),
            primaryButton: .default(Text("Clear")) {
                viewModel.deleteAllPages()
            },
            secondaryButton: .cancel()
        )
    }

    var clearAllHistoryButton: some View {
        Button {
            isShowingDeleteAllHistoryAlert = true
        } label: {
            Image(systemName: "trash")
        }
    }

    // MARK: List

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

    var emptyList: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()

            Spacer()
        }
    }
}
