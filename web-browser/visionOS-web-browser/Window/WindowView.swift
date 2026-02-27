import SwiftUI

struct WindowView: View {
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel

    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    let menu: MenuView
    let tabBar: TabBarView

    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                menu
            } detail: {
                ZStack(alignment: .top) {
                    tabBar
                    if shouldShowSearchSuggestions {
                        searchSuggestions
                    }
                }
            }
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.top),
            contentAlignment: .center
        )
        {
            HStack {
                MainToolbar(tabViewModel: tabBarManager.selectedTab.tabViewModel, columnVisibility: $columnVisibility)
            }
            .frame(width: 1000)
            .padding()
            .glassBackgroundEffect()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        }
    }

    var shouldShowSearchSuggestions: Bool {
        tabBarManager.selectedTab.tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        SearchSuggestionView(viewModel: searchSuggestionViewModel)
            .frame(width: 550)
            .zIndex(2)
    }
}

struct MainToolbar: View {
    @ObservedObject var tabViewModel: TabViewModel
    @Binding var columnVisibility: NavigationSplitViewVisibility

    var body: some View {
        HStack {
            toggleMenuButton
            navigationButtons
            Spacer()
            addressBar
            Spacer()
            if let url = URL(string: tabViewModel.fullURL) {
                shareLink(url)
            }
        }
    }

    var toggleMenuButton: some View {
        Button(action: {
            withAnimation {
                if columnVisibility == .detailOnly {
                    columnVisibility = .all
                } else {
                    columnVisibility = .detailOnly
                }
            }
        }) {
            Image(systemName: "sidebar.left")
        }
    }

    var navigationButtons: some View {
        NavigationBar(viewModel: tabViewModel)
    }

    var addressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            .frame(minWidth: 0, maxWidth: 800)
    }

    func shareLink(_ url: URL) -> some View {
        ShareLink(item: url) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 17))
        }
        .buttonStyle(.borderless)
    }
}
