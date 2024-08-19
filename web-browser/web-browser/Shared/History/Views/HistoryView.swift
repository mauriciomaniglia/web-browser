import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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

                Spacer()

                ForEach(viewModel.historyList.indices, id: \.self) { index in
                    let item = viewModel.historyList[index]

                    HStack {
                        Text("\(item.title)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.didSelectPageHistory?(item)
                    }

                    if index < viewModel.historyList.count-1 {
                        Divider()
                    }
                }
                .presentationCompactAdaptation((.popover))
            }
            .padding()
        }
        .navigationTitle("History")
        .onAppear {
            viewModel.didOpenHistoryView?()
        }
    }
}
