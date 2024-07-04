import SwiftUI

struct HistoryView: View {
    var didSelectPage: ((MenuViewModel.HistoryPage) -> Void)?
    let pages: [MenuViewModel.HistoryPage]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
