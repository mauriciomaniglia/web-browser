import SwiftUI

#if canImport(UIKit)
struct TabContentViewIPadOS: View {
    @ObservedObject var tabViewModel: TabViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(tabViewModel.showWebView ? 1 : 0)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WindowNavigationButtons(viewModel: tabViewModel)
            }
            ToolbarItem(placement: .principal) {
                AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
                    .popover(isPresented: $tabViewModel.showSearchSuggestions, attachmentAnchor: .point(.bottom)) {
                        SearchSuggestionView(viewModel: tabViewModel.searchSuggestionViewModel)
                            .frame(width: 550)
                    }
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
