import SwiftUI

#if os(macOS)
struct MacOSHistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        SearchTopBar
            .navigationTitle("History")
            .onAppear {
                viewModel.didOpenHistoryView?()
            }

        if hasPagesSelected() {
            SelectedPagesView
        }

        if isHistoryEmpty() {
            EmptyView
        } else {
            HistoryList
        }
    }

    private var SearchTopBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
            }
            TextField("Search History", text: $searchText)
                .onChange(of: searchText, { _, newValue in
                    viewModel.didSearchTerm?(newValue)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button {
                isShowingDeleteAllHistoryAlert = true
            } label: {
                Text("Delete All")
            }
            .alert(isPresented: $isShowingDeleteAllHistoryAlert) {
                Alert(
                    title: Text("Clear all browsing history?"),
                    primaryButton: .default(Text("Clear")) {
                        viewModel.deleteAllPages()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
    }

    private var SelectedPagesView: some View {
        HStack {
            Button {
                viewModel.deselectAllPages()
            } label: {
                Image(systemName: "xmark")
            }
            Text("\(viewModel.selectedPages.count) selected")
            Spacer()
            Button {
                viewModel.deleteSelectedPages()
            } label: {
                Text("Delete")
            }
        }
        .padding()
    }

    private var HistoryList: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { sectionIndex in
                let item = viewModel.historyList[sectionIndex]
                let header = Text(item.title)
                Section(header: header) {
                    ForEach(item.pages.indices, id: \.self) { pageIndex in
                        let page = item.pages[pageIndex]
                        Toggle(isOn: $viewModel.historyList[sectionIndex].pages[pageIndex].isSelected) {
                            Text(page.title)
                                .onTapGesture {
                                    viewModel.didSelectPage?(page.url)
                                    dismiss()
                                }
                                .onHover { hovering in
                                    if hovering {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .padding()
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

    private func hasPagesSelected() -> Bool {
        viewModel.selectedPages.count > 0
    }

    private func isHistoryEmpty() -> Bool {
        viewModel.historyList.isEmpty
    }
}
#endif
