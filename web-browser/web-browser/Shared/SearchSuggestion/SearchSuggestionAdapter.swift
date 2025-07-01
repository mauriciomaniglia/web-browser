import Foundation
import Services

final class SearchSuggestionAdapter {
    let viewModel: SearchSuggestionViewModel

    init(viewModel: SearchSuggestionViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: SearchSuggestionPresentableModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.bookmarkSuggestions = model.bookmarkSuggestions.map { .init(title: $0.title, url: $0.url)}
            self?.viewModel.historyPageSuggestions = model.historyPageSuggestions.map { .init(title: $0.title, url: $0.url)}
            self?.viewModel.searchSuggestions = model.searchSuggestions.map { .init(title: $0.title, url: $0.url) }
        }
    }
}
