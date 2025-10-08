import SwiftUI

class TabBarViewModel: ObservableObject {

    struct Tab {
        let id: UUID
        let view: any View
    }

    let tabFactory: TabFactory

    @Published var tabs: [Tab] = []

    init(tabFactory: TabFactory) {
        self.tabFactory = tabFactory
    }

    func createNewTab() {
        let tab = Tab(id: UUID(), view: tabFactory.createNewTab())
        tabs.append(tab)
    }

    func removeTab(id: UUID) {
        tabs.removeAll(where: { $0.id == id})
    }
}
