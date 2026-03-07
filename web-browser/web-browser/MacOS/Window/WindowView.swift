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
                    tabBar
                    tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
                }
            }
        }
    }
}
