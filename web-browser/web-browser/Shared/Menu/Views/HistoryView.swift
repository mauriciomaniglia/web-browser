import SwiftUI

struct HistoryView: View {
    var didSelectHistory: ((Int) -> Void)?
    let historyList: [MenuViewModel.HistoryPage]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(historyList.indices, id: \.self) { index in
                    let item = historyList[index]

                    HStack {
                        Text("\(item.title)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        didSelectHistory?(index)
                    }

                    if index < historyList.count-1 {
                        Divider()
                    }
                }
                .presentationCompactAdaptation((.popover))
            }
            .padding()
        }
    }
}
