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

                    let header = Text(item.title)
                        .font(.title)
                        .bold()
                        .padding(.bottom)

                    Section(header: header) {
                        ForEach(item.pages, id: \.url) { page in
                            Spacer()
                            HStack {
                                Text("\(page.title)")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.didSelectPageHistory?(page)
                                dismiss()
                            }
                        }

                        if index < viewModel.historyList.count-1 {
                            Divider()
                        }
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
