import SwiftUI

struct HistoryView: View {
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

        List {
            ForEach(viewModel.historyList.indices, id: \.self) { index in
                let item = viewModel.historyList[index]

                let header = Text(item.title)

                Section(header: header) {
                    ForEach(item.pages, id: \.url) { page in
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
        .navigationTitle("History")
        .onAppear {
            viewModel.didOpenHistoryView?()
        }
    }

    func delete(at offsets: IndexSet) {

    }
}
