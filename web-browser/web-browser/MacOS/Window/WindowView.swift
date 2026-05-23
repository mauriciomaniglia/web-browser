import SwiftUI

struct WindowView: View {
    let menu: MenuView
    let tabsCollectionBarView: TabsCollectionBarView
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    var body: some View {
        ZStack {
            NavigationSplitView {
                menu
            } detail: {
                VStack {
                    tabsCollectionBarView
                    tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
                }
            }
        }
    }
}
