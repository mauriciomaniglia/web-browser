import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Binding var isShowingHistory: Bool
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        VStack {
            header
            searchBar
            if isHistoryEmpty {
                emptyList
            } else {
                historyList
            }
        }
        .padding()
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
        Text("History")
            .font(.title2)
            .bold()
    }

    var closeButton: some View {
        Button(action: {
            isShowingHistory.toggle()
        }) {
            Text("Done")
        }
    }

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
                                isShowingHistory.toggle()
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
