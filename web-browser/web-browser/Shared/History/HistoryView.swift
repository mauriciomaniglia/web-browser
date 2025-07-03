import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @State private var searchText: String = ""
    @State private var isShowingDeleteAllHistoryAlert = false

    var body: some View {
        VStack {
            SearchTopBarView

            if viewModel.historyList.isEmpty {
                EmptyView
            } else {
                HistoryListView
            }
        }
        .navigationTitle("History")
        .onAppear(perform: viewModel.didOpenHistoryView)
        .alert(isPresented: $isShowingDeleteAllHistoryAlert) { ClearAllHistoryAlert }
    }

    // MARK: SubViews

    var SearchTopBarView: some View {
        HStack {
            SearchTextField
            ClearAllHistoryButton
        }
        .padding()
    }

    var HistoryListView: some View {
        List {
            ForEach(viewModel.historyList.indices, id: \.self) { index in
                HistoryListItem(viewModel: viewModel, index: index)
            }
        }
    }

    var EmptyView: some View {
        VStack {
            Text("No history found.")
                .font(.headline)
                .padding()

            Spacer()
        }
    }

    var SearchTextField: some View {
        TextField("Search History", text: $searchText)
            .onChange(of: searchText, { _, newValue in viewModel.didSearchTerm?(newValue) })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }

    var ClearAllHistoryButton: some View {
        Button { isShowingDeleteAllHistoryAlert = true } label: { Image(systemName: "trash") }
    }

    var ClearAllHistoryAlert: Alert {
        Alert(
            title: Text("Clear all browsing history?"),
            primaryButton: .default(Text("Clear")) { viewModel.deleteAllPages() },
            secondaryButton: .cancel()
        )
    }
}

struct HistoryListItem: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: HistoryViewModel
    let index: Int

    var body: some View {
        let item = viewModel.historyList[index]
        let headerTitle = Text(item.title)

        Section(header: headerTitle) {
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
