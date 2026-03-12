import Foundation

@MainActor
public class HistoryManager<T: HistoryStoreAPI> {
    private let historyStore: T

    public init(historyStore: T) {
        self.historyStore = historyStore
    }

    public func didOpenHistoryView() -> HistoryViewData {
        let pages = historyStore.getPages()
        return convertToPresentableModel(pages)
    }

    public func didSearchTerm(_ term: String) async -> HistoryViewData {
        let pages = term.isEmpty ? historyStore.getPages() : historyStore.getPages(by: term)
        return convertToPresentableModel(pages)
    }

    private func convertToPresentableModel(_ pages: [WebPageModel]) -> HistoryViewData {
        let groupedPages = Dictionary(grouping: pages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
            lhs.key.compare(rhs.key) == .orderedDescending
        })
        let groupPagesSorted: [[WebPageModel]] = sortedGroups.map { _, pages in
            pages.sorted(by: { $0.date > $1.date })
        }

        let model = HistoryViewData(list: mapSections(groupPagesSorted))

        return model
    }

    private func mapSections(_ pages: [[WebPageModel]]) -> [HistoryViewData.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            return HistoryViewData.Section(title: title, pages: mapPages($0))
        }
    }

    private func mapPages(_ pages: [WebPageModel]) -> [HistoryViewData.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString

            return HistoryViewData.Page(id: $0.id, title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}

public struct HistoryViewData {
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
