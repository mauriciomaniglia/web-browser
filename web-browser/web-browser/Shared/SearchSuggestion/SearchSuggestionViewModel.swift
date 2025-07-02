import Foundation
import Combine

class SearchSuggestionViewModel: ObservableObject {

    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @Published var bookmarkSuggestions: [Item] = []
    @Published var historyPageSuggestions: [Item] = []
    @Published var searchSuggestions: [Item] = []

    var didStartTyping: ((String) -> Void)?
    var didSelectPage: ((URL) -> Void)?
}
