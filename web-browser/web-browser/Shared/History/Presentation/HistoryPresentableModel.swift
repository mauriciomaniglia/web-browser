import Foundation

struct HistoryPresentableModel {

    struct HistoryPage: Equatable {
        let title: String
        let url: URL
    }

    let historyList: [HistoryPage]?
}
