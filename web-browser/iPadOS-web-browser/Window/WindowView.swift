import SwiftUI

struct WindowView: View {
    let tabsCollectionView: TabsCollectionView
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>
    @State private var isShowingTabManager = false

    var body: some View {
        VStack {
            HStack {
                tabsCollectionView
                newTabButton
                showAllTabsButton
            }
            .background(Color.indigo)
            tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
        }
        .fullScreenCover(isPresented: $isShowingTabManager) {
            tabCollectionView
        }
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

    var showAllTabsButton: some View {
        Button(action: {
            Task {
                await tabBarManager.captureSnapshots()
                isShowingTabManager = true
            }
        }) {
            Image(systemName: "square.on.square")
                .padding(8)
                .background(Color.clear)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }

    var tabCollectionView: some View {
        TabCollectionView(tabBarManager: tabBarManager, isPresented: $isShowingTabManager)
    }
}
