import SwiftUI

struct WindowView: View {
    let tabBar: TabBarView
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    var body: some View {
        VStack {
            HStack {
                tabBar
                newTabButton
            }
            .background(Color.indigo)
            tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
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
