import SwiftUI

#if canImport(UIKit)
struct TabContentViewIPadOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(windowViewModel.showWebView ? 1 : 0)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WindowNavigationButtons(viewModel: windowViewModel)
            }
            ToolbarItem(placement: .principal) {
                AddressBarView(viewModel: windowViewModel, searchText: $windowViewModel.fullURL)
                    .popover(isPresented: $windowViewModel.showSearchSuggestions, attachmentAnchor: .point(.bottom)) {
                        SearchSuggestionView(viewModel: windowViewModel.searchSuggestionViewModel)
                            .frame(width: 550)
                    }
            }
            if let url = URL(string: windowViewModel.fullURL) {
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
