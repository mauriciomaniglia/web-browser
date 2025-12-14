import SwiftUI

#if os(macOS)
struct TabContentView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var searchSuggestionViewModel: SearchSuggestionViewModel

    let webView: WebView

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                WindowNavigationButtons(viewModel: tabViewModel)
                Spacer()
                AddressBar
                Spacer()
                if let url = URL(string: tabViewModel.fullURL) {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 17))
                    }
                    .buttonStyle(.borderless)
                }
            }
            if tabViewModel.showSearchSuggestions {
                SearchSuggestionView(viewModel: searchSuggestionViewModel)                    
                    .frame(width: 550)
                    .offset(y: 42)
                    .zIndex(2)
            }
            Spacer()
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(tabViewModel.showWebView ? 1 : 0)
                .offset(y: 60)
                .zIndex(1)
        }
        .padding()
    }

    // MARK: SubViews

    var AddressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            .frame(minWidth: 0, maxWidth: 800)
    }
}
#endif
