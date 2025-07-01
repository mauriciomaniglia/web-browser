import Foundation
import Combine

class SearchSuggestionViewModel: ObservableObject {

    struct Bookmark: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    struct HistoryPage: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    struct SearchSuggestion: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @Published var bookmarkSuggestions: [Bookmark] = []
    @Published var historyPageSuggestions: [HistoryPage] = []
    @Published var searchSuggestions: [SearchSuggestion] = []

    var didStartTyping: ((String) -> Void)?
    var didSelectPage: ((URL) -> Void)?
}
