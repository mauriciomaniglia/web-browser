import Foundation

@MainActor
public class HistoryManager<T: HistoryStoreAPI> {
    private let store: T

    public init(store: T) {
        self.store = store
    }

    public func loadViewData() -> HistoryViewData {
        let pages = store.getPages()
        return getViewData(from: pages)
    }

    public func loadViewData(from term: String) async -> HistoryViewData {
        let pages = term.isEmpty ? store.getPages() : store.getPages(by: term)
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

        let model = HistoryViewData(list: getViewDataSections(from: groupPagesSorted))

        return model
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
