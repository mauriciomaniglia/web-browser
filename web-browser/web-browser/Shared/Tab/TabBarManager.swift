import SwiftData
import SwiftUI
import Services

protocol TabBarStore {
    func getTabSessions() async -> [String: Data]?
    func saveTabSession(tabID: UUID, sessionData: Data) async
    func deleteTabSession(tabID: UUID) async
}

@MainActor
final class TabBarManager<T: TabBarStore>: ObservableObject {
    @Published var tabs: [TabComposer] = []
    @Published var selectedTab: TabComposer?

    let windowViewModel: WindowViewModel

    let tabBarStore: T

    init(windowViewModel: WindowViewModel, tabBarStore: T) {
        self.windowViewModel = windowViewModel
        self.tabBarStore = tabBarStore

        windowViewModel.historyComposer.userActionDelegate = self
        windowViewModel.bookmarkComposer.userActionDelegate = self
        windowViewModel.searchSuggestionComposer.userActionDelegate = self
    }

    func start() {
        let orderedIDs = UserDefaults.standard.stringArray(forKey: "ordered_tab_ids") ?? []

        if orderedIDs.count == 0 {
            createNewTab()
        } else {
            fetchTabs(orderedIDs: orderedIDs)
        }
    }

    func fetchTabs(orderedIDs: [String]) {
        Task { @MainActor in
            guard let tabSessions = await tabBarStore.getTabSessions() else { return }

            for tabID in orderedIDs {
                let webKitWrapper = WebKitEngineWrapper()

                if let sessionData = tabSessions[tabID] {
                    webKitWrapper.sessionData = sessionData
                }

                let composer = TabComposer(
                    tabID: UUID(uuidString: tabID),
                    userActionDelegate: self,
                    webKitWrapper: webKitWrapper,
                    windowViewModel: windowViewModel
                )

                tabs.append(composer)
                selectedTab = composer
            }
        }
    }

    func createNewTab() {
        let webKitWrapper = WebKitEngineWrapper()

        let composer = TabComposer(
            userActionDelegate: self,
            webKitWrapper: webKitWrapper,
            windowViewModel: windowViewModel
        )

        tabs.append(composer)
        selectedTab = composer

        if  let sessionData = composer.webKitWrapper.sessionData, composer.tabViewModel.showWebView == true {
            Task {
                await tabBarStore.saveTabSession(tabID: composer.id, sessionData: sessionData)
            }
        }
    }

    func saveTabSessionData(tabID: UUID) {
        let tab = tabs.first(where: { $0.id == tabID })

        if let tab, let sessionData = tab.webKitWrapper.sessionData {
            Task {
                await tabBarStore.saveTabSession(tabID: tab.id, sessionData: sessionData)
            }
        }
    }

    func didSelectTab(at index: Int) {
        selectedTab = tabs[index]

        if let tab = selectedTab, let sessionData = tab.webKitWrapper.sessionData {
            Task {
                await tabBarStore.saveTabSession(tabID: tab.id, sessionData: sessionData)
            }
        }
    }

    func closeTab(at index: Int) {
        let tabID = tabs[index].id

        if index == 0 && tabs.count == 1 {
            tabs.remove(at: 0)
            selectedTab = nil
            createNewTab()
            return
        }

        selectedTab = (index > 0) ? tabs[index - 1] : tabs[index + 1]
        tabs.remove(at: index)
        persistTabOrder()

        Task {
            await tabBarStore.deleteTabSession(tabID: tabID)
        }
    }

    func closeAllTabs() {
        tabs.removeAll()
        selectedTab = nil
        createNewTab()
    }

    private func persistTabOrder() {
        let idStrings = tabs.map { $0.id.uuidString }
        UserDefaults.standard.set(idStrings, forKey: "ordered_tab_ids")
    }
}

extension TabBarManager: TabUserActionDelegate {
    func didLoadPage(tabID: UUID) {
        saveTabSessionData(tabID: tabID)
        persistTabOrder()
    }

    func didTapNewTab() {
        createNewTab()
    }
}

extension TabBarManager: HistoryUserActionDelegate {
    func didSelectPage(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabBarManager: SearchSuggestionUserActionDelegate {
    func didSelectPageFromSearchSuggestion(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}

extension TabBarManager: BookmarkUserActionDelegate {
    func didSelectPageFromBookmark(_ pageURL: URL) {
        selectedTab?.webKitWrapper.load(pageURL)
    }
}
