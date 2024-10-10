import SwiftUI

#if os(iOS)
struct IOSWindow: View {
    @ObservedObject var windowViewModel: WindowViewModel
    @State var isShowingSheet = false

    let webView: AnyView

    var body: some View {
        VStack {
            AddressBarView(viewModel: windowViewModel)
            webView
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            HStack {
                WindowNavigationButtons(viewModel: windowViewModel)

                Spacer()

                Button(action: { isShowingSheet.toggle() }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding()
        }
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            IOSMenuView(windowViewModel: windowViewModel, isPresented: $isShowingSheet)
        })
    }
}

#endif
