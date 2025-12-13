import SwiftUI

#if canImport(UIKit)
struct TabContentViewIPadOS: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel

    let webView: WebView

    var body: some View {
        ZStack(alignment: .top) {
            if tabViewModel.showSearchSuggestions {
                SearchSuggestionView(viewModel: searchSuggestionViewModel)
                    .frame(width: 550)
                    .offset(y: 0)
                    .zIndex(2)
            }
            Spacer()
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(tabViewModel.showWebView ? 1 : 0)
                .zIndex(1)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WindowNavigationButtons(viewModel: tabViewModel)
            }
            ToolbarItem(placement: .principal) {
                AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            }
            if let url = URL(string: tabViewModel.fullURL) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
#endif
