import SwiftUI

struct Window: View {
    let menu: Menu
    let tabBarController: TabBarViewControllerWrapper

    var body: some View {
        ZStack {
            NavigationSplitView {
                menu
            } detail: {
                tabBarController
            }
        }
    }
}
