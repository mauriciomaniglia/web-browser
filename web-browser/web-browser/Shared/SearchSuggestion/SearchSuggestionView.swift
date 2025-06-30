import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel
    var didSelectPage: ((Int) -> Void)?

    var body: some View {
        List {
            if !viewModel.searchSuggestions.isEmpty {
                Section(header: Text("Google suggestions")) {
                    ForEach(viewModel.searchSuggestions, id: \.title) { model in
                        HStack {
                            Text("\(model.title)")
                            Spacer()
                        }
                    }
                }
            }

            if !viewModel.bookmarkSuggestions.isEmpty {
                Section(header: Text("Bookmark")) {
                    ForEach(viewModel.bookmarkSuggestions, id: \.title) { model in
                        HStack {
                            Text("\(model.title)")
                            Spacer()
                        }
                    }
                }
            }

            if !viewModel.historyPageSuggestions.isEmpty {
                Section(header: Text("History")) {
                    ForEach(viewModel.historyPageSuggestions, id: \.title) { model in
                        HStack {
                            Text("\(model.title)")
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
