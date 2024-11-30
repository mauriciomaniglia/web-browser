import Foundation

public class HistoryPresenter {
    public var didUpdatePresentableModel: ((HistoryPresentableModel) -> Void)?

    public init() {}

    public func didLoadPages(_ pages: [HistoryPageModel]) {
        let groupedPages = Dictionary(grouping: pages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
            lhs.key.compare(rhs.key) == .orderedDescending
        })
        let groupPagesSorted: [[HistoryPageModel]] = sortedGroups.map { _, pages in
            pages.sorted(by: { $0.date > $1.date })
        }

        let model = HistoryPresentableModel(list: mapSections(groupPagesSorted))
        didUpdatePresentableModel?(model)
    }

    private func mapSections(_ pages: [[HistoryPageModel]]) -> [HistoryPresentableModel.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            return HistoryPresentableModel.Section(title: title, pages: mapPages($0))
        }
    }

    private func mapPages(_ pages: [HistoryPageModel]) -> [HistoryPresentableModel.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString

            return HistoryPresentableModel.Page(id: $0.id, title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}
