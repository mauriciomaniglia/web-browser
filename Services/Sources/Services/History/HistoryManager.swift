import Foundation

public class HistoryManager<T: HistoryStoreAPI> {
    private let store: T
    private var pages: [WebPageModel] = []
    private var lastQuery: String = ""

    public init(store: T) {
        self.store = store
    }

    public func loadViewData(from term: String) -> HistoryViewData {
        if term.isEmpty && pages.isEmpty {
            pages = store.getPages(after: nil, limit: 100, query: nil)
        } else if term.isEmpty && pages.isEmpty == false {
            pages += store.getPages(after: pages.last?.date, limit: 100, query: nil)
        } else if term == lastQuery && pages.isEmpty == false {
            pages = store.getPages(after: pages.last?.date, limit: 100, query: term)
        } else {
            lastQuery = term
            pages = store.getPages(after: nil, limit: 100, query: term)
        }
        return getViewData(from: pages)
    }

    private func getViewData(from pages: [WebPageModel]) -> HistoryViewData {
        let groupedPages = Dictionary(grouping: pages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
            lhs.key.compare(rhs.key) == .orderedDescending
        })
        let groupPagesSorted: [[WebPageModel]] = sortedGroups.map { _, pages in
            pages.sorted(by: { $0.date > $1.date })
        }
        return HistoryViewData(list: getViewDataSections(from: groupPagesSorted))
    }

    private func getViewDataSections(from pages: [[WebPageModel]]) -> [HistoryViewData.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            let pages = getViewDataPages($0)
            return HistoryViewData.Section(title: title, pages: pages)
        }
    }

    private func getViewDataPages(_ pages: [WebPageModel]) -> [HistoryViewData.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString
            return HistoryViewData.Page(id: $0.id, title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}
