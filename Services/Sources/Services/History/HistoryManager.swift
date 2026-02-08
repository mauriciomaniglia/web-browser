import Foundation

public class HistoryManager<T: HistoryStoreAPI> {
    private let historyStore: T

    public init(historyStore: T) {
        self.historyStore = historyStore
    }

    public func didOpenHistoryView() -> PresentableHistory {
        let pages = historyStore.getPages()
        return convertToPresentableModel(pages)
    }

    public func didSearchTerm(_ term: String) -> PresentableHistory {
        let pages = term.isEmpty ? historyStore.getPages() : historyStore.getPages(by: term)
        return convertToPresentableModel(pages)
    }

    private func convertToPresentableModel(_ pages: [WebPageModel]) -> PresentableHistory {
        let groupedPages = Dictionary(grouping: pages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
            lhs.key.compare(rhs.key) == .orderedDescending
        })
        let groupPagesSorted: [[WebPageModel]] = sortedGroups.map { _, pages in
            pages.sorted(by: { $0.date > $1.date })
        }

        let model = PresentableHistory(list: mapSections(groupPagesSorted))

        return model
    }

    private func mapSections(_ pages: [[WebPageModel]]) -> [PresentableHistory.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            return PresentableHistory.Section(title: title, pages: mapPages($0))
        }
    }

    private func mapPages(_ pages: [WebPageModel]) -> [PresentableHistory.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString

            return PresentableHistory.Page(id: $0.id, title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}

public struct PresentableHistory {
    public struct Section: Equatable {
        public let title: String
        public let pages: [Page]
    }

    public struct Page: Equatable {
        public let id: UUID
        public let title: String
        public let url: URL
    }

    public let list: [Section]?
}
