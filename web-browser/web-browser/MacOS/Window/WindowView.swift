import SwiftUI

struct WindowView: View {
    let tabsCollectionBarView: TabsCollectionBarView

    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    @ObservedObject var historyViewModel: HistoryViewModel  
    @ObservedObject var menuViewModel = MenuViewModel()

    var body: some View {
        ZStack {
            NavigationSplitView {
                MenuView(menuViewModel: menuViewModel)
            } detail: {
                NavigationStack(path: $menuViewModel.path) {
                    VStack {
                        tabsCollectionBarView
                        selectedTabView
                    }
                    .navigationDestination(for: MenuOption.self) { menuOption in
                        switch menuOption {
                        case .bookmarks:
                            BookmarkView(viewModel: bookmarkViewModel)
                        case .history:
                            HistoryView(viewModel: historyViewModel)
                        }
                    }
                }
            }
        }
    }

    var selectedTabView: some View {
        tabBarManager.selectedTab.view.id(tabBarManager.selectedTab.id)
    }
}
