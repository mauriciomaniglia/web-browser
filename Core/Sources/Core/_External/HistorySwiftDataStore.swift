import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

public class HistorySwiftDataStore: HistoryAPI {
    @Model
    public class HistoryPage {
        @Attribute(.unique) public var id: UUID
        var title: String
        var url: URL
        var date: Date
        var urlString: String

        init(id: UUID, title: String, url: URL, date: Date, urlString: String) {
            self.id = id
            self.title = title
            self.url = url
            self.date = date
            self.urlString = urlString
        }
    }

    private let container: ModelContainer
    private lazy var backgroundContext = ModelContext(container)

    public init(container: ModelContainer) {
        self.container = container
    }

    public func save(page: WebPage) {
        let title = page.title ?? ""
        let historyTitle = title.isEmpty ? page.url.absoluteString : title

        let historyPage = HistoryPage(
            id: page.id,
            title: historyTitle,
            url: page.url,
            date: Date(),
            urlString: page.url.absoluteString)

        backgroundContext.insert(historyPage)

        try? backgroundContext.save()
    }

    public func getPages() -> [WebPage] {
        let allPages = FetchDescriptor<HistoryPage>(sortBy: [.init(\.date)])

        do {
            let results = try backgroundContext.fetch(allPages)
            return results.map { WebPage(id: $0.id, title: $0.title, url: $0.url, date: $0.date) }
        } catch {
            return []
        }
    }

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
            let results = try backgroundContext.fetch(filteredPages)
            return results.map { WebPage(id: $0.id, title: $0.title, url: $0.url, date: $0.date) }
        } catch {
            return []
        }
    }

    public func deletePages(withIDs ids: [UUID]) {
        let predicate = #Predicate<HistoryPage> { page in
            ids.contains(page.id)
        }

        let pagesToDelete = FetchDescriptor<HistoryPage>(predicate: predicate)

        do {
            let results = try backgroundContext.fetch(pagesToDelete)
            for page in results {
                backgroundContext.delete(page)
            }
            try backgroundContext.save()
        } catch {
            print("Error deleting pages: \(error)")
        }
    }

    public func deleteAllPages() {
        let pagesToDelete = FetchDescriptor<HistoryPage>()

        do {
            let results = try backgroundContext.fetch(pagesToDelete)
            for page in results {
                backgroundContext.delete(page)
            }
            try backgroundContext.save()
        } catch {
            print("Error deleting all pages: \(error)")
        }
    }
}
