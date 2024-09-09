import SwiftUI

struct IOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @ObservedObject var historyViewModel: HistoryViewModel

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: windowViewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)
                Spacer()
                IOSMenuButton(historyViewModel: historyViewModel)
            }
            .padding()
        }
    }
}

