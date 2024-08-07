import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    @State private var searchText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    Text("History")

                    HStack {
                        TextField("Search History", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {}) {
                            Text("Cancel")
                        }
                    }
                    .cornerRadius(10)
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
    }
}
