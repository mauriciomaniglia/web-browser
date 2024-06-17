import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

public class HistoryStore: HistoryAPI {
    private let container = try? ModelContainer(for: HistoryPage.self)

    public init() {}

    @MainActor
    public func save(page: WebPage) {
        guard let context = container?.mainContext else { return }

        let pagetitle = page.title ?? ""
        let historyTitle = pagetitle.isEmpty ? page.url.absoluteString : pagetitle

        context.insert(HistoryPage(title: historyTitle, url: page.url, date: Date()))
        try? context.save()
    }
    
    @MainActor
    public func getPages() -> [WebPage] {
        guard let context = container?.mainContext else { return [] }

        let allPages = FetchDescriptor<HistoryPage>(
            sortBy: [
                .init(\.date)
            ]
        )

        do {
            let results = try context.fetch(allPages)            
            return results.map { WebPage(title: $0.title, url: $0.url) }
        } catch {
            return []
        }
    }
}
