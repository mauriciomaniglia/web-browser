import Foundation
import SwiftData

@available(iOS 17, *)
@available(macOS 14, *)

@Model
class HistoryPage {
    let title: String
    let url: URL
    let date: Date

    init(title: String, url: URL, date: Date) {
        self.title = title
        self.url = url
        self.date = date
    }
}
