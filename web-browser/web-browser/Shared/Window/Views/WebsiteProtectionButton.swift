import SwiftUI

struct WebsiteProtectionButton: View {
    @ObservedObject var viewModel: WindowViewModel
    @State var isShowingSheet = false

    var body: some View {
        Button(action: { isShowingSheet.toggle() }) {
            Image(systemName: viewModel.isWebsiteProtected ? "shield.fill": "shield.slash")
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.gray)
        .popover(isPresented: $isShowingSheet, content: {
            VStack(alignment: .leading) {
                Text(viewModel.url ?? "")

                Toggle("Protection for this website", isOn: $viewModel.isWebsiteProtected)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: viewModel.isWebsiteProtected) { oldValue, newValue in
                        viewModel.didUpdateSafelist?(viewModel.url ?? "", oldValue)
                    }

                .presentationDetents([.large, .medium])
            }
            .padding()
        })
    }
}
