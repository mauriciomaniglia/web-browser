import Foundation

public struct HistoryPresentableModel {

    public struct HistoryPage: Equatable {
        public let title: String
        public let url: URL
    }

    public let historyList: [HistoryPage]?
}
