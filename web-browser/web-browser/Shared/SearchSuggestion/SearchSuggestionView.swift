import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    var body: some View {
        List {
            if !viewModel.searchSuggestions.isEmpty {
                Section(header: Text("Google suggestions")) {
                    ForEach(viewModel.searchSuggestions) { model in
                        HStack {
                            Text("\(model.title)")
                                .onTapGesture {
                                    viewModel.didSelectPage?(model.url)
                                }
                            Spacer()
                        }
                    }
                }
            }

            if !viewModel.bookmarkSuggestions.isEmpty {
                Section(header: Text("Bookmark")) {
                    ForEach(viewModel.bookmarkSuggestions) { model in
                        HStack {
                            Text("\(model.title)")
                                .onTapGesture {
                                    viewModel.didSelectPage?(model.url)
                                }
                            Spacer()
                        }
                    }
                }
            }

            if !viewModel.historyPageSuggestions.isEmpty {
                Section(header: Text("History")) {
                    ForEach(viewModel.historyPageSuggestions) { model in
                        HStack {
                            Text("\(model.title)")
                                .onTapGesture {
                                    viewModel.didSelectPage?(model.url)
                                }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
