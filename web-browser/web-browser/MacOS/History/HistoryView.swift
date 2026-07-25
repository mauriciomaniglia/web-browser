import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        VStack {
            searchBar
            if hasPagesSelected {
                selectedPagesBar
            }
            if isHistoryEmpty {
                emptyList
            } else {
                historyList
            }
        }
        .navigationTitle("History")
        .task {
            viewModel.delegate?.didOpenHistoryView()
        }
    }

    var searchBar: some View {
        HStack {
            searchTextField
            deleteAllButton
        }
        .padding()
    }

    var searchTextField: some View {
        TextField("Search History", text: $searchText)
            .task(id: searchText) {
                try? await Task.sleep(for: .milliseconds(300))
                viewModel.delegate?.didSearchTerm(searchText)
            }
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

    var hasPagesSelected: Bool {
        viewModel.selectedPages.count > 0
    }

    var selectedPagesTotal: Int {
        viewModel.selectedPages.count
    }

    var selectedPagesBar: some View {
        HStack {
            Button {
                viewModel.deselectAllPages()
            } label: {
                Image(systemName: "xmark")
            }
            Text("\(selectedPagesTotal) selected")
            Spacer()
            Button {
                viewModel.deleteSelectedPages()
            } label: {
                Text("Delete")
            }
        }
        .padding()
    }

    var isHistoryEmpty: Bool {
        viewModel.historyList.isEmpty
    }

    var historyList: some View {
        List {
            ForEach(viewModel.historyList) { section in
                let header = Text(section.title)
                Section(header: header) {
                    ForEach(section.pages) { page in
                        historyRow(page: page)
                    }
                }
            }
        }
    }

    func historyRow(page: HistoryViewModel.Page) -> some View {
        Toggle(isOn: Binding<Bool>(
            get: { page.isSelected },
            set: { _ in viewModel.toggleSelection(for: page.id) }
        )) {
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

    var emptyList: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }
}
