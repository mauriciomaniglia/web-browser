import SwiftUI

struct Window: View {
    let menu: Menu
    let tabBar: TabBarView

    var body: some View {
        ZStack {
            NavigationSplitView {
                menu
            } detail: {
                tabBar
            }
        }
    }
}
