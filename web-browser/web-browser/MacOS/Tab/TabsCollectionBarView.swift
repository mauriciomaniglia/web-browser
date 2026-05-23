import SwiftUI

struct TabsCollectionBarView: View {
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    let tabsCollectionView: TabsCollectionView

    var body: some View {
        HStack {
            tabsCollectionView
            newTabButton
        }
        .background(Color.purple)
    }

    var newTabButton: some View {
        Button(action: tabBarManager.createNewTab) {
            Image(systemName: "plus")
                .padding(8)
                .background(Color.clear)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}
