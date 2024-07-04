import core_web_browser

class MenuPresenter {
    private let history: HistoryAPI

    var didUpdatePresentableModel: ((MenuModel) -> Void)?

    init(history: HistoryAPI) {
        self.history = history
    }

    func didOpenMenuView() {
        let model = MenuModel(showMenu: true, historyList: nil)
        didUpdatePresentableModel?(model)
    }

    func didOpenHistoryView() {
        let pages = history.getPages().sorted { $0.date > $1.date }
        let model = MenuModel(showMenu: false, historyList: mapHistoryPages(pages))
        didUpdatePresentableModel?(model)
    }

    func didSelectPageHistory() {
        let model = MenuModel(showMenu: false, historyList: nil)
        didUpdatePresentableModel?(model)
    }

    private func mapHistoryPages(_ pages: [WebPage]) -> [MenuModel.HistoryPage] {
        pages.map {
            let title = $0.title ?? ""
            return MenuModel.HistoryPage.init(
                title: title.isEmpty ? $0.url.absoluteString : title,
                url: $0.url)
        }
    }
}
