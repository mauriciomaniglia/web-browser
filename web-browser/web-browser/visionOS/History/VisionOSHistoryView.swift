import SwiftUI

#if os(visionOS)
struct VisionOSHistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        VStack {
            SearchTopBar

            if isHistoryEmpty() {
                EmptyView
            } else {
                HistoryList
            }
        }
        .onAppear {
            viewModel.didOpenHistoryView?()
        }
        .navigationTitle("History")
        .alert(isPresented: $isShowingDeleteAllHistoryAlert) {
            ClearAllHistoryAlert
        }
    }

    private var SearchTopBar: some View {
        HStack {
            BackButton
            SearchTextField
            ClearAllHistoryButton
        }
        .padding()
    }

    private var HistoryList: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { index in
                let item = viewModel.historyList[index]

                let header = Text(item.title)

                Section(header: header) {
                    ForEach(item.pages) { page in
                        Text("\(page.title)")
                            .onTapGesture {
                                viewModel.didSelectPage?(page.url)
                                dismiss()
                            }
                    }
                    .onDelete { offsets in
                        viewModel.deletePages(at: offsets, inSection: index)
                    }
                }
            }
        }
    }

    private var EmptyView: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    private var SearchTextField: some View {
        TextField("Search History", text: $searchText)
            .onChange(of: searchText, { _, newValue in
                viewModel.didSearchTerm?(newValue)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }

    private var BackButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }

    private var ClearAllHistoryButton: some View {
        Button {
            isShowingDeleteAllHistoryAlert = true
        } label: {
            Image(systemName: "trash")
        }
    }

    private var ClearAllHistoryAlert: Alert {
        Alert(
            title: Text("Clear all browsing history?"),
            primaryButton: .default(Text("Clear")) {
                viewModel.deleteAllPages()
            },
            secondaryButton: .cancel()
        )
    }

    private func isHistoryEmpty() -> Bool {
        viewModel.historyList.isEmpty
    }
}
#endif
