import Foundation

class HistoryViewModel: ObservableObject {

    struct Section {
        let title: String
        var pages: [Page]
    }

    struct Page: Identifiable {
        let id: UUID
        let title: String
        let url: String
        var isSelected: Bool = false

        mutating func select() {
            isSelected.toggle()
        }
    }

    @Published var historyList: [Section] = []

    var selectedPages: [Page] {
        return historyList
            .flatMap { $0.pages }
            .filter { $0.isSelected }
    }

    var didOpenHistoryView: (() -> Void)?
    var didSearchTerm: ((String) -> Void)?
    var didSelectPage: ((String) -> Void)?

    func deselectAllPages() {
        for sectionIndex in historyList.indices {
            for pageIndex in historyList[sectionIndex].pages.indices {
                historyList[sectionIndex].pages[pageIndex].isSelected = false
            }
        }
    }
}
