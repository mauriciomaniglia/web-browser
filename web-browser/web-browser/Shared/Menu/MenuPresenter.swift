import core_web_browser

class MenuPresenter {
    private let history: HistoryAPI

    init(history: HistoryAPI) {
        self.history = history
    }

    func didOpenMenuView() -> MenuModel {
        MenuModel(showMenu: true, historyList: nil)
    }

    func didOpenHistoryView() -> MenuModel {
        let pages = history.getPages()
        return MenuModel(showMenu: false, historyList: mapHistoryPages(pages))
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
