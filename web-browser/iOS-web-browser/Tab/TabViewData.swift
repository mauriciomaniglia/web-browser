import SwiftUI

struct TabViewData: Identifiable {
    let id = UUID()
    var title: String
    var screenshotColor: Color = Color.gray.opacity(0.3)
}

class TabManager: ObservableObject {
    @Published var tabs: [TabViewData] = []

    func closeTab(tab: TabViewData) {
        tabs.removeAll { $0.id == tab.id }
    }

    func addNewTab() {
        let newTab = TabViewData(title: "New Tab (\(tabs.count + 1))", screenshotColor: .purple.opacity(0.5))
        tabs.append(newTab)
    }
}
