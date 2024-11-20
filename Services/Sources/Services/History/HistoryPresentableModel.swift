import Foundation

public struct HistoryPresentableModel {

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
