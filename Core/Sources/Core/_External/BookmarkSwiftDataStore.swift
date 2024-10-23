import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

public class BookmarkSwiftDataStore: BookmarkAPI {
    @Model
    public class Bookmark {
        @Attribute(.unique) public var id: UUID
        var title: String
        var url: URL

        init(id: UUID, title: String, url: URL) {
            self.id = id
            self.title = title
            self.url = url
        }
    }

    private let container: ModelContainer
    private lazy var backgroundContext = ModelContext(container)

    public init(container: ModelContainer) {
        self.container = container
    }

    public func save(page: WebPage) {
        let title = page.title ?? ""

        let bookmark = Bookmark(
            id: page.id,
            title: title.isEmpty ? page.url.absoluteString : title,
            url: page.url)

        backgroundContext.insert(bookmark)

        try? backgroundContext.save()
    }

    public func getPages() -> [WebPage] {
        let allPages = FetchDescriptor<Bookmark>()

        do {
            let results = try backgroundContext.fetch(allPages)
            return results.map { WebPage(id: $0.id, title: $0.title, url: $0.url, date: Date()) }
        } catch {
            return []
        }
    }

    public func getPages(by searchTerm: String) -> [WebPage] {
        let predicate = #Predicate<Bookmark> { page in
            page.title.contains(searchTerm)
        }

        let filteredBookmarks = FetchDescriptor<Bookmark>(
            predicate: predicate
        )

        do {
            let results = try backgroundContext.fetch(filteredBookmarks)
            return results.map { WebPage(id: $0.id, title: $0.title, url: $0.url, date: Date()) }
        } catch {
            return []
        }
    }

    public func deletePages(withIDs ids: [UUID]) {
        let predicate = #Predicate<Bookmark> { page in
            ids.contains(page.id)
        }

        let bookmarksToDelete = FetchDescriptor<Bookmark>(predicate: predicate)

        do {
            let results = try backgroundContext.fetch(bookmarksToDelete)
            for bookmark in results {
                backgroundContext.delete(bookmark)
            }
            try backgroundContext.save()
        } catch {
            print("Error deleting pages: \(error)")
        }
    }
}
