import Foundation
import SwiftData
import Services

public class BookmarkSwiftDataStore: BookmarkStoreAPI {
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

    public func save(_ bookmark: BookmarkModel) {
        let title = bookmark.title ?? ""

        let bookmark = Bookmark(
            id: bookmark.id,
            title: title.isEmpty ? bookmark.url.absoluteString : title,
            url: bookmark.url)

        backgroundContext.insert(bookmark)

        try? backgroundContext.save()
    }

    public func getPages() -> [BookmarkModel] {
        let allPages = FetchDescriptor<Bookmark>()

        do {
            let results = try backgroundContext.fetch(allPages)
            return results.map { BookmarkModel(id: $0.id, title: $0.title, url: $0.url) }
        } catch {
            return []
        }
    }

    public func getPages(by searchTerm: String) -> [BookmarkModel] {
        let predicate = #Predicate<Bookmark> { page in
            page.title.contains(searchTerm)
        }

        let filteredBookmarks = FetchDescriptor<Bookmark>(
            predicate: predicate
        )

        do {
            let results = try backgroundContext.fetch(filteredBookmarks)
            return results.map { BookmarkModel(id: $0.id, title: $0.title, url: $0.url) }
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
