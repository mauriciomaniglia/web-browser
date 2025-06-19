import Services

final class SearchSuggestionAdapter {
    let viewModel: SearchSuggestionViewModel

    init(viewModel: SearchSuggestionViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: SearchSuggestionPresentableModel) {
        viewModel.bookmarkSuggestions = model.bookmarkSuggestions.map { .init(title: $0.title, url: $0.url)}
        viewModel.historyPageSuggestions = model.historyPageSuggestions.map { .init(title: $0.title, url: $0.url)}
        viewModel.searchSuggestions = model.searchSuggestions.map { .init(title: $0.title, url: $0.url) }
    }
}
