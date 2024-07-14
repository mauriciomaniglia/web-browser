import SwiftUI

struct HistoryView: View {
    var didSelectPage: ((MenuViewModel.HistoryPage) -> Void)?
    let pages: [MenuViewModel.HistoryPage]

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

                ForEach(pages.indices, id: \.self) { index in
                    let item = pages[index]

                    HStack {
                        Text("\(item.title)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        didSelectPage?(item)
                    }

                    if index < pages.count-1 {
                        Divider()
                    }
                }
                .presentationCompactAdaptation((.popover))
            }
            .padding()
        }
    }
}
