import SwiftUI

struct WindowView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel

    let menu: MenuView
    let tabBar: TabBarView

    var body: some View {
        ZStack {
            NavigationSplitView {
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
                mainToolbar
            }
            .frame(width: 1000)
            .padding()
            .glassBackgroundEffect()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        }
    }

    var mainToolbar: some View {
        HStack {
            navigationButtons
            Spacer()
            addressBar
            Spacer()
            if let url = URL(string: tabViewModel.fullURL) {
                shareLink(url)
            }
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

    var shouldShowSearchSuggestions: Bool {
        tabViewModel.showSearchSuggestions
    }

    var searchSuggestions: some View {
        SearchSuggestionView(viewModel: searchSuggestionViewModel)
            .frame(width: 550)
            .zIndex(2)
    }
}
