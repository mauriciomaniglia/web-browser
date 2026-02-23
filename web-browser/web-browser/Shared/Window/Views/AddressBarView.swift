import SwiftUI

struct AddressBarView: View {
    @ObservedObject var viewModel: TabViewModel
    @Binding var searchText: String

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

            ProgressBar
        }
    }

    private var SearchTextField: some View {
        TextField("Search or enter address", text: $searchText)
            .autocorrectionDisabled()
            #if os(iOS)
            .textInputAutocapitalization(.never)
            #endif
            .textFieldStyle(.plain)
            .onSubmit { viewModel.didStartSearch?(searchText) }
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { _, isFocused in
                viewModel.didChangeFocus?(isFocused)
            }
            .onChange(of: searchText) { oldText, newText in
                viewModel.didStartTyping?(oldText, newText)
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
        ProgressView(value: viewModel.progressBarValue ?? 0, total: 1.0)
            .opacity(viewModel.progressBarValue != nil ? 1 : 0)
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
    }

    private func didTapCancelButton() {
        isTextFieldFocused = false
        viewModel.didChangeFocus?(isTextFieldFocused)
    }
}
