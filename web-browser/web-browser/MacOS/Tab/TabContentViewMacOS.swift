import SwiftUI

#if os(macOS)
struct TabContentViewMacOS: View {
    @ObservedObject var windowViewModel: WindowViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)
                Spacer()
                AddressBar
                Spacer()
                if let url = URL(string: windowViewModel.fullURL) {
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
                .opacity(windowViewModel.showWebView ? 1 : 0)
        }
        .padding()
    }

    // MARK: SubViews

    var AddressBar: some View {
        AddressBarView(viewModel: windowViewModel, searchText: $windowViewModel.fullURL)
            .frame(minWidth: 0, maxWidth: 800)
            .popover(isPresented: $windowViewModel.showSearchSuggestions, attachmentAnchor: .point(.center)) {
                SearchSuggestionView(viewModel: windowViewModel.searchSuggestionViewModel)
                    .frame(width: 550)
            }
    }
}
#endif
