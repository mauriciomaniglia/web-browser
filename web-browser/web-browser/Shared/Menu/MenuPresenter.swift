import Foundation
import core_web_browser

struct MenuModel {

    struct HistoryPage: Equatable {
        let title: String
        let url: URL
    }

    let showMenu: Bool
    let historyList: [HistoryPage]?
}

class MenuPresenter {
    private let history: HistoryAPI

    init(history: HistoryAPI) {
        self.history = history
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
