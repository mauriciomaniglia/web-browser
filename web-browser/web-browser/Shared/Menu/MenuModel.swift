import Foundation

struct MenuModel {

    struct HistoryPage: Equatable {
        let title: String
        let url: URL
    }

    let showMenu: Bool
    let historyList: [HistoryPage]?
}
