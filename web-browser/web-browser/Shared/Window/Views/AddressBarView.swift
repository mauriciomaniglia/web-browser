import SwiftUI

struct AddressBarView: View {
    @ObservedObject var viewModel: WindowViewModel
    @State var searchText: String

    @State private var isShowingSheet = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    HStack {
                        if viewModel.showSiteProtection {
                            WebsiteProtectionButton(viewModel: viewModel, isShowingSheet: isShowingSheet)
                        }

                        SearchTextField

                        if viewModel.showStopButton {
                            StopButton
                        }

                        if viewModel.showReloadButton {
                            ReloadButton
                        }

                        if viewModel.showClearButton {
                            ClearButton
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

                #if os(iOS)
                if viewModel.showCancelButton {
                    CancelButton
                }
                #endif
            }
            .padding(.horizontal)

            if (viewModel.progressBarValue != nil) {
                ProgressBar
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                isTextFieldFocused = false
            }
        }
    }

    private var SearchTextField: some View {
        TextField("Search or enter address", text: $searchText)
            .textFieldStyle(.plain)
            .onSubmit { viewModel.didStartSearch?(searchText) }
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { _, isFocused in
                if isFocused {
                    viewModel.didBeginEditing?()
                } else {
                    viewModel.didEndEditing?()
                }
            }
    }

    private var StopButton: some View {
        Button(action: { viewModel.didStopLoading?() }) {
            Image(systemName: "xmark")
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var ReloadButton: some View {
        Button(action: { viewModel.didReload?() }) {
            Image(systemName: "goforward")
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var ClearButton: some View {
        Button(action: { searchText = "" }) {
            Image(systemName: "xmark.circle")
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var CancelButton: some View {
        Button(action: { didTapCancelButton() }) {
            Text("Cancel")
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var ProgressBar: some View {
        ProgressView(value: viewModel.progressBarValue, total: 1.0)
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
    }

    private func didTapCancelButton() {
        isTextFieldFocused = false
        viewModel.didTapCancelButton?()
    }
}
