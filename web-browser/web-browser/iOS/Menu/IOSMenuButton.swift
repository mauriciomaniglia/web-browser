import SwiftUI

struct IOSMenuButton: View {
    @ObservedObject var viewModel: MenuViewModel
    @State var isShowingSheet = false

    var body: some View {
        Button(action: { isShowingSheet.toggle() }) {
            Image(systemName: "line.3.horizontal")
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.primary)
        .popover(isPresented: $isShowingSheet, arrowEdge: .trailing, content: {
            IOSMenuView(viewModel: viewModel)
        })
    }
}
