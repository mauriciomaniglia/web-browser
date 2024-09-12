import Foundation

class HistoryViewModel: ObservableObject {

    struct Section {
        let title: String
        var pages: [Page]
    }

    struct Page: Identifiable {
        let id = UUID()
        let title: String
        let url: String
        var isSelected: Bool = false

        mutating func select() {
            isSelected.toggle()
        }
    }

    @Published var historyList: [Section] = []

    var didOpenHistoryView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPage: ((String) -> Void)?
}
