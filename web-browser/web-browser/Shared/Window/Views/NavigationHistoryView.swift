import SwiftUI

struct NavigationHistoryView: View {
    var didSelectPage: ((Int) -> Void)?
    let pageList: [WindowViewModel.WebPage]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(pageList.indices, id: \.self) { index in
                let page = pageList[index]

                HStack {
                    Text("\(page.title)")
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    didSelectPage?(index)
                }

                if index < pageList.count-1 {
                    Divider()
                }
            }
            .presentationCompactAdaptation((.popover))
        }
        .padding()
    }
}
