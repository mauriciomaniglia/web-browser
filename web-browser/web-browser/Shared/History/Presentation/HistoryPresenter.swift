import core_web_browser

class HistoryPresenter {
    private let history: HistoryAPI

    var didUpdatePresentableModel: ((HistoryPresentableModel) -> Void)?

    init(history: HistoryAPI) {
        self.history = history
    }

    func didOpenHistoryView() {
        let pages = history.getPages().sorted { $0.date > $1.date }
        let model = HistoryPresentableModel(historyList: mapHistoryPages(pages))
        didUpdatePresentableModel?(model)
    }

    private func mapHistoryPages(_ pages: [WebPage]) -> [HistoryPresentableModel.HistoryPage] {
        pages.map {
            let title = $0.title ?? ""
            return HistoryPresentableModel.HistoryPage.init(
                title: title.isEmpty ? $0.url.absoluteString : title,
                url: $0.url)
        }
    }
}
