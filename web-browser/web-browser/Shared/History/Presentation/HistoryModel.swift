import Foundation

struct HistoryModel {

    struct HistoryPage: Equatable {
        let title: String
        let url: URL
    }

    let historyList: [HistoryPage]?
}
