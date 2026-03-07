import SwiftUI

struct WindowView: View {
    let tabBar: TabBarView
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    var body: some View {
        VStack {
            tabBar
            tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
        }
    }
}
