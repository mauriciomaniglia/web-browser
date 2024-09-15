import SwiftUI

struct MacOSHistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var body: some View {
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

        if viewModel.selectedPages.count > 0 {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                }

                Text("\(viewModel.selectedPages.count) selected")
            }
        }

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
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            viewModel.didOpenHistoryView?()
        }
    }

    func delete(at offsets: IndexSet) {

    }
}
