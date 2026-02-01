import SwiftData
import SwiftUI
import Services

final class TabBarManager: ObservableObject {
    @Published var tabs: [TabComposer] = []
    @Published var selectedTab: TabComposer?

    let windowViewModel: WindowViewModel

    let tabSessionStore = TabSessionStore()

    init(windowViewModel: WindowViewModel) {
        self.windowViewModel = windowViewModel

        windowViewModel.historyComposer.userActionDelegate = self
        windowViewModel.bookmarkComposer.userActionDelegate = self
        windowViewModel.searchSuggestionComposer.userActionDelegate = self
    }

    func fetchTabs() {
        Task { @MainActor in
            guard let tabSessions = await tabSessionStore.getTabSessions(), !tabSessions.keys.isEmpty else { return }

            tabs.removeAll()
            selectedTab = nil

            for tabID in tabSessions.keys {
                let webKitWrapper = WebKitEngineWrapper()

                if let sessionData = tabSessions[tabID] {
                    webKitWrapper.sessionData = sessionData
                }

                let composer = TabComposer(
                    tabID: UUID(uuidString: tabID),
                    userActionDelegate: self,
                    webKitWrapper: webKitWrapper,
                    bookmarkViewModel: windowViewModel.bookmarkComposer.viewModel,
                    historyViewModel: windowViewModel.historyComposer.viewModel,
                    searchSuggestionViewModel: windowViewModel.searchSuggestionComposer.viewModel,
                    safelistStore: windowViewModel.safelistStore,
                    historyStore: windowViewModel.historyStore
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
            bookmarkViewModel: windowViewModel.bookmarkComposer.viewModel,
            historyViewModel: windowViewModel.historyComposer.viewModel,
            searchSuggestionViewModel: windowViewModel.searchSuggestionComposer.viewModel,
            safelistStore: windowViewModel.safelistStore,
            historyStore: windowViewModel.historyStore
        )

        tabs.append(composer)
        selectedTab = composer

        if  let sessionData = composer.webKitWrapper.sessionData, composer.tabViewModel.showWebView == true {
            Task {
                await tabSessionStore.saveTabSession(tabID: composer.id, sessionData: sessionData)
            }
        }
    }

    func saveTabSessionData(tabID: UUID) {
        let tab = tabs.first(where: { $0.id == tabID })

        if let tab, let sessionData = tab.webKitWrapper.sessionData {
            Task {
                await tabSessionStore.saveTabSession(tabID: tab.id, sessionData: sessionData)
            }
        }
    }

    func didSelectTab(at index: Int) {
        selectedTab = tabs[index]

        if let tab = selectedTab, let sessionData = tab.webKitWrapper.sessionData {
            Task {
                await tabSessionStore.saveTabSession(tabID: tab.id, sessionData: sessionData)
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

        Task {
            await tabSessionStore.deleteTabSession(tabID: tabID)
        }
    }

    func closeAllTabs() {
        tabs.removeAll()
        selectedTab = nil
        createNewTab()
    }
}

extension TabBarManager: TabUserActionDelegate {
    func didLoadPage(tabID: UUID) {
        saveTabSessionData(tabID: tabID)
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
