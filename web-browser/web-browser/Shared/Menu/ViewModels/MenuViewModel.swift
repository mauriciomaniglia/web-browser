import Foundation

class MenuViewModel: ObservableObject {

    struct HistoryPage {
        let title: String
        let url: URL
    }

    @Published var showMenu: Bool = false
    @Published var showHistory: Bool = false
    @Published var historyList: [HistoryPage] = []

    var didTapMenuButton: (() -> Void)?
    var didTapHistoryOption: (() -> Void)?
    var didSelectPageHistory: ((HistoryPage) -> Void)?
}
