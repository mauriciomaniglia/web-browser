import Foundation
import Combine

@MainActor
protocol SearchSuggestionViewModelDelegate: AnyObject {
    func didStartTyping(_ text: String)
    func didSelectPage(_ pageURL: URL)
}

@MainActor
class SearchSuggestionViewModel: ObservableObject {

    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @Published var bookmarkSuggestions: [Item] = []
    @Published var historyPageSuggestions: [Item] = []
    @Published var searchSuggestions: [Item] = []

    weak var delegate: SearchSuggestionViewModelDelegate?
}
