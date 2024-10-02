import SwiftUI

#if os(macOS)
struct MacOSHistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var body: some View {
        searchTopBar
        if viewModel.selectedPages.count > 0 {
            selectedPagesView
        }
        historyList
        .navigationTitle("History")
        .onAppear {
            viewModel.didOpenHistoryView?()
        }
    }

    var searchTopBar: some View {
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
        }
        .padding()
    }

    var selectedPagesView: some View {
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
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .padding()
                    }
                }
            }
        }
    }
}
#endif
