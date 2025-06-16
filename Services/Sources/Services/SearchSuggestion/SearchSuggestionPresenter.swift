import Foundation

public class SearchSuggestionPresenter {
    public var didUpdatePresentableModel: ((SearchSuggestionPresentableModel) -> Void)?

    public init() {}

    public func didLoad(searchSuggestions: [String], historyModels: [HistoryPageModel], bookmarkModels: [BookmarkModel]) {

        let searchSuggestionModels = searchSuggestions.map { suggestion in
            SearchSuggestionPresentableModel.SearchSuggestion(
                title: suggestion,
                url: URLBuilderAPI.makeURL(from: suggestion)
            )
        }
        .prefix(10)
        .map { $0 }

        let historySuggestions = historyModels.compactMap { model in
            model.title.map { SearchSuggestionPresentableModel.HistoryPage(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let bookmarkSuggestions = bookmarkModels.compactMap { model in
            model.title.map { SearchSuggestionPresentableModel.Bookmark(title: $0, url: model.url) }
        }
        .prefix(10)
        .map { $0 }

        let model = SearchSuggestionPresentableModel(
            bookmarkSuggestions: bookmarkSuggestions,
            historyPageSuggestions: historySuggestions,
            searchSuggestions: searchSuggestionModels
        )

        didUpdatePresentableModel?(model)
    }
}
