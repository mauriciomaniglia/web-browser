import Foundation
import Combine

class SearchSuggestionViewModel: ObservableObject {

    struct Bookmark {
        let title: String
        let url: URL
    }

    struct HistoryPage {
        let title: String
        let url: URL
    }

    struct SearchSuggestion {
        let title: String
        let url: URL
    }

    @Published var bookmarkSuggestions: [Bookmark] = []
    @Published var historyPageSuggestions: [HistoryPage] = []
    @Published var searchSuggestions: [SearchSuggestion] = []
}
