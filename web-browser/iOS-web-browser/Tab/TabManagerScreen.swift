import SwiftUI

struct TabManagerScreen: View {
    var tabManager: TabManager
    @Binding var isPresented: Bool

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(tabManager.tabs.indices, id: \.self) { index in
                        TabCardView(isPresented: $isPresented, tab: tabManager.tabs[index], index: index)
                            .environmentObject(tabManager)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .background(Color(.systemGroupedBackground))

            ToolbarView(isPresented: $isPresented)
                .environmentObject(tabManager)

        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
