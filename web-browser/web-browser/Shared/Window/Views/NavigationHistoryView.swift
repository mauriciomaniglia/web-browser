import SwiftUI

struct NavigationHistoryView: View {
    let pageList: [WindowViewModel.WebPage]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(pageList.indices, id: \.self) { index in
                let page = pageList[index]

                Text("\(page.title)")
                    .onTapGesture {
                        print("Did select at: \(index)")
                    }

                Divider()
            }
            .presentationCompactAdaptation((.popover))
        }
        .padding()
    }
}
