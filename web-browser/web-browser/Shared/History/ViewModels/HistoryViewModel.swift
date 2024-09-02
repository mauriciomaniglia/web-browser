import Foundation

class HistoryViewModel: ObservableObject {

    struct Section {
        let title: String
        let pages: [Page]
    }

    struct Page {
        let title: String
        let url: String
    }

    @Published var historyList: [Section] = []

    var didOpenHistoryView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPageHistory: ((Page) -> Void)?
}
