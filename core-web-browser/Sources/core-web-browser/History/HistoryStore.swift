import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

public class HistoryStore: HistoryAPI {
    @Model
    class HistoryPage {
        let title: String
        let url: URL
        let date: Date
        let urlString: String

        init(title: String, url: URL, date: Date, urlString: String) {
            self.title = title
            self.url = url
            self.date = date
            self.urlString = urlString
        }
    }

    private let container = try? ModelContainer(for: HistoryPage.self)

    public init() {}

    @MainActor
    public func save(page: WebPage) {
        guard let context = container?.mainContext else { return }

        let pagetitle = page.title ?? ""
        let historyTitle = pagetitle.isEmpty ? page.url.absoluteString : pagetitle

        context.insert(HistoryPage(title: historyTitle, url: page.url, date: Date(), urlString: page.url.absoluteString))
        try? context.save()
    }

    @MainActor
    public func getPages() -> [[WebPage]] {
        guard let context = container?.mainContext else { return [] }

        let allPages = FetchDescriptor<HistoryPage>(sortBy: [.init(\.date)])

        do {
            let results = try context.fetch(allPages)
            let webPages = results.map { WebPage(title: $0.title, url: $0.url, date: $0.date) }

            let groupedPages = Dictionary(grouping: webPages, by: { Calendar.current.startOfDay(for: $0.date) })
            let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
                lhs.key.compare(rhs.key) == .orderedDescending
            })

            return sortedGroups.map { $0.value }

        } catch {
            return []
        }
    }

    @MainActor
    public func getPages(by searchTerm: String) -> [[WebPage]] {
        guard let context = container?.mainContext else { return [] }
        guard !searchTerm.isEmpty else { return getPages() }

        let predicate = #Predicate<HistoryPage> { page in
            page.title.contains(searchTerm) ||
            page.urlString.contains(searchTerm)
        }

        let filteredPages = FetchDescriptor<HistoryPage>(
            predicate: predicate,
            sortBy: [.init(\.date)]
        )

        do {
            let results = try context.fetch(filteredPages)
            let webPages = results.map { WebPage(title: $0.title, url: $0.url, date: $0.date) }

            let groupedPages = Dictionary(grouping: webPages, by: { Calendar.current.startOfDay(for: $0.date) })
            let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
                lhs.key.compare(rhs.key) == .orderedDescending
            })

            return sortedGroups.map { $0.value }
        } catch {
            return []
        }
    }
}
