import SwiftUI

struct History: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        searchBar

        if hasPagesSelected {
            selectedPages
        }

        if isHistoryEmpty {
            emptyList
        } else {
            historyList
        }
    }

    var searchBar: some View {
        HStack {
            dismissButton
            searchTextField
            deleteAllButton
        }
        .padding()
        .navigationTitle("History")
        .onAppear(perform: viewModel.delegate?.didOpenHistoryView)
    }

    var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left")
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

    var deleteAllButton: some View {
        Button {
            isShowingDeleteAllHistoryAlert = true
        } label: {
            Text("Delete All")
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

    var selectedPages: some View {
        HStack {
            Button {
                viewModel.deselectAllPages()
            } label: {
                Image(systemName: "xmark")
            }
            Text("\(viewModel.selectedPages.count) selected")
            Spacer()
            Button {
                viewModel.deleteSelectedPages()
            } label: {
                Text("Delete")
            }
        }
        .padding()
    }

    var historyList: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { sectionIndex in
                let item = viewModel.historyList[sectionIndex]
                let header = Text(item.title)
                Section(header: header) {
                    ForEach(item.pages.indices, id: \.self) { pageIndex in
                        let page = item.pages[pageIndex]
                        Toggle(isOn: $viewModel.historyList[sectionIndex].pages[pageIndex].isSelected) {
                            Text(page.title)
                                .onTapGesture {
                                    viewModel.delegate?.didSelectPage(page.url)
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
                        .toggleStyle(CheckboxToggleStyle())
                        .padding()
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

    var hasPagesSelected: Bool {
        viewModel.selectedPages.count > 0
    }

    var isHistoryEmpty: Bool {
        viewModel.historyList.isEmpty
    }
}
