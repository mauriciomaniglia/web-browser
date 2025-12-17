import SwiftUI

struct TabManagerScreen: View {
    @StateObject var tabManager = TabManager()

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(tabManager.tabs) { tab in
                        TabCardView(tab: tab)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .background(Color(.systemGroupedBackground))

        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
