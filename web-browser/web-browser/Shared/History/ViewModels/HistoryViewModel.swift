import Foundation

class HistoryViewModel: ObservableObject {

    struct HistoryPage {
        let title: String
        let url: URL
    }

    @Published var historyList: [HistoryPage] = []

    var didOpenHistoryView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPageHistory: ((HistoryPage) -> Void)?
}
