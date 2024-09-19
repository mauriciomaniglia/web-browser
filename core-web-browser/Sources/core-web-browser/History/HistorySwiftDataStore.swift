import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

public class HistorySwiftDataStore: HistoryAPI {
    @Model
    class HistoryPage {
        @Attribute(.unique) let id: UUID
        let title: String
        let url: URL
        let date: Date
        let urlString: String

        init(title: String, url: URL, date: Date, urlString: String) {
            self.id = UUID()
            self.title = title
            self.url = url
            self.date = date
            self.urlString = urlString
        }
    }

    private let container: ModelContainer

    public init() {
        do {
            container = try ModelContainer(for: HistoryPage.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    @MainActor
    public func save(page: WebPage) {
        let pagetitle = page.title ?? ""
        let historyTitle = pagetitle.isEmpty ? page.url.absoluteString : pagetitle

        container.mainContext.insert(HistoryPage(title: historyTitle, url: page.url, date: Date(), urlString: page.url.absoluteString))

        try? container.mainContext.save()
    }

    @MainActor
    public func getPages() -> [WebPage] {
        let allPages = FetchDescriptor<HistoryPage>(sortBy: [.init(\.date)])

        do {
            let results = try container.mainContext.fetch(allPages)
            return results.map { WebPage(title: $0.title, url: $0.url, date: $0.date) }
        } catch {
            return []
        }
    }

    @MainActor
    public func getPages(by searchTerm: String) -> [WebPage] {
        let predicate = #Predicate<HistoryPage> { page in
            page.title.contains(searchTerm) ||
            page.urlString.contains(searchTerm)
        }

        let filteredPages = FetchDescriptor<HistoryPage>(
            predicate: predicate,
            sortBy: [.init(\.date)]
        )

        do {
            let results = try container.mainContext.fetch(filteredPages)
            return results.map { WebPage(title: $0.title, url: $0.url, date: $0.date) }
        } catch {
            return []
        }
    }

    @MainActor
    public func deletePages(withIDs ids: [UUID]) {
        let predicate = #Predicate<HistoryPage> { page in
            ids.contains(page.id)
        }

        let pagesToDelete = FetchDescriptor<HistoryPage>(predicate: predicate)

        do {
            let results = try container.mainContext.fetch(pagesToDelete)
            for page in results {
                container.mainContext.delete(page)
            }
            try container.mainContext.save()
        } catch {
            print("Error deleting pages: \(error)")
        }
    }
}
