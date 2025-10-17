import Foundation
import Combine

protocol HistoryViewModelDelegate: AnyObject {
    func didOpenHistoryView()
    func didSearchTerm(_ query: String)
    func didSelectPage(_ pageURL: URL)
    func didTapDeletePages(_ pages: [UUID])
    func didTapDeleteAllPages()
}

class HistoryViewModel: ObservableObject {

    struct Section: Equatable {
        let title: String
        var pages: [Page]
    }

    struct Page: Identifiable, Equatable {
        let id: UUID
        let title: String
        let url: URL
        var isSelected: Bool = false

        mutating func select() {
            isSelected.toggle()
        }
    }

    @Published var historyList: [Section] = []

    weak var delegate: HistoryViewModelDelegate?

    var selectedPages: [Page] {
        return historyList
            .flatMap { $0.pages }
            .filter { $0.isSelected }
    }

    func deselectAllPages() {
        for sectionIndex in historyList.indices {
            for pageIndex in historyList[sectionIndex].pages.indices {
                historyList[sectionIndex].pages[pageIndex].isSelected = false
            }
        }
    }

    func deleteSelectedPages() {
        delegate?.didTapDeletePages(selectedPages.map { $0.id })

        for sectionIndex in historyList.indices {
            historyList[sectionIndex].pages.removeAll(where: { $0.isSelected })
        }
        removeSectionsThatHaveNoPagesLeft()
    }

    func deletePages(at offsets: IndexSet, inSection sectionIndex: Int) {
        let pagesToDelete = offsets.compactMap { index in
            historyList[sectionIndex].pages.indices.contains(index) ? historyList[sectionIndex].pages[index] : nil
        }

        delegate?.didTapDeletePages(pagesToDelete.map { $0.id })
    }

    func deleteAllPages() {
        delegate?.didTapDeleteAllPages()
        historyList.removeAll()
    }

    private func removeSectionsThatHaveNoPagesLeft() {
        historyList.removeAll(where: { $0.pages.isEmpty })
    }
}
