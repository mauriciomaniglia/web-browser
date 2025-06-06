import Foundation

public struct SearchSuggestionPresentableModel {

    public struct Bookmark {
        public let title: String
        public let url: URL
    }

    public struct HistoryPage {
        public let title: String
        public let url: URL
    }

    public struct SearchSuggestion {
        public let title: String
        public let url: URL
    }

    public let bookmarkSuggestions: [Bookmark]
    public let historyPageSuggestions: [HistoryPage]
    public let searchSuggestions: [SearchSuggestion]
}
