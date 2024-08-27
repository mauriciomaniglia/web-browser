public class HistoryPresenter {
    private let history: HistoryAPI

    public var didUpdatePresentableModel: ((HistoryPresentableModel) -> Void)?

    public init(history: HistoryAPI) {
        self.history = history
    }

    public func didOpenHistoryView() {
        let pages: [[WebPage]] = history.getPages()
        let model = HistoryPresentableModel(list: mapSections(pages))
        didUpdatePresentableModel?(model)
    }

    public func didSearchTerm(_ term: String) {
        let pages = history.getPages(by: term)
        let model = HistoryPresentableModel(list: mapSections(pages))
        didUpdatePresentableModel?(model)
    }

    private func mapSections(_ pages: [[WebPage]]) -> [HistoryPresentableModel.Section] {
        pages.map {
            let title = $0.first?.date.relativeTimeString() ?? ""
            return HistoryPresentableModel.Section(title: title, pages: mapPages($0))
        }
    }

    private func mapPages(_ pages: [WebPage]) -> [HistoryPresentableModel.Page] {
        pages.map {
            let title = $0.title ?? ""
            let dateAndTitle = $0.date.formattedTime() + " - " + title
            let dateAndURL = $0.date.formattedTime() + " - " + $0.url.absoluteString

            return HistoryPresentableModel.Page(title: title.isEmpty ? dateAndURL : dateAndTitle, url: $0.url)
        }
    }
}
