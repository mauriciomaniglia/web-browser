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
                    selectedTabView
                }
            }
        }
    }

    var selectedTabView: some View {
        tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
    }
}
