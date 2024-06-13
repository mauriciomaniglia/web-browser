import SwiftUI

struct NavigationHistoryView: View {
    var didSelectPage: ((Int) -> Void)?
    let pageList: [WindowViewModel.WebPage]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(pageList.indices, id: \.self) { index in
                let page = pageList[index]

                Text("\(page.title)")
                    .onTapGesture {
                        didSelectPage?(index)
                    }

                Divider()
            }
            .presentationCompactAdaptation((.popover))
        }
        .padding()
    }
}
