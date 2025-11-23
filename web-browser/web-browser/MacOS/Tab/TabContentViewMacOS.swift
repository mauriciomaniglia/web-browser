import SwiftUI

#if os(macOS)
struct TabContentViewMacOS: View {
    @ObservedObject var tabViewModel: TabViewModel

    let webView: AnyView

    var body: some View {
        VStack {
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
            Spacer()
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(tabViewModel.showWebView ? 1 : 0)
        }
        .padding()
    }

    // MARK: SubViews

    var AddressBar: some View {
        AddressBarView(viewModel: tabViewModel, searchText: $tabViewModel.fullURL)
            .frame(minWidth: 0, maxWidth: 800)
            .popover(isPresented: $tabViewModel.showSearchSuggestions, attachmentAnchor: .point(.center)) {
                SearchSuggestionView(viewModel: tabViewModel.searchSuggestionViewModel)
                    .frame(width: 550)
            }
    }
}
#endif
