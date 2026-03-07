import SwiftUI

struct WindowView: View {
    let menu: MenuView
    let tabBar: TabBarView
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    var body: some View {
        ZStack {
            NavigationSplitView {
                menu
            } detail: {
                VStack {
                    HStack {
                        tabBar
                        newTabButton
                    }
                    .background(Color.purple)
                    tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
                }
            }
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
}
