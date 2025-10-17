import Foundation

public protocol HistoryPresenterDelegate: AnyObject {
    func didUpdatePresentableModel(_ model: HistoryPresenter.Model)
}

public class HistoryPresenter {

    public struct Model {
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

    public weak var delegate: HistoryPresenterDelegate?

    public init() {}

    public func didLoadPages(_ pages: [HistoryPageModel]) {
        let groupedPages = Dictionary(grouping: pages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroups = groupedPages.sorted(by: { lhs, rhs in
            lhs.key.compare(rhs.key) == .orderedDescending
        })
        let groupPagesSorted: [[HistoryPageModel]] = sortedGroups.map { _, pages in
            pages.sorted(by: { $0.date > $1.date })
        }

        let model = Model(list: mapSections(groupPagesSorted))
        delegate?.didUpdatePresentableModel(model)
    }

    private func mapSections(_ pages: [[HistoryPageModel]]) -> [Model.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            return Model.Section(title: title, pages: mapPages($0))
        }
    }

    private func mapPages(_ pages: [HistoryPageModel]) -> [Model.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString

            return Model.Page(id: $0.id, title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}
