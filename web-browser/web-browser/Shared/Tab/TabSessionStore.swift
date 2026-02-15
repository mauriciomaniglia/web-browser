import Foundation

actor TabSessionStore: TabBarStore {
    let fileManager = FileManager.default
    let tabPrefix = "tab-"

    func saveTabSession(tabID: UUID, sessionData: Data) async {
        guard let directory = tabDirectory() else { return }

        let path = directory.appendingPathComponent(tabPrefix + tabID.uuidString)

        try? sessionData.write(to: path, options: .atomicWrite)
    }

    func deleteTabSession(tabID: UUID) async {
        guard let directory = tabDirectory() else { return }

        let path = directory.appendingPathComponent(tabPrefix + tabID.uuidString)

        try? fileManager.removeItem(at: path)
    }

    func getTabSessions() async -> [String: Data]? {
        guard let directory = tabDirectory() else { return nil }

        let contentsOfDirectory = try? fileManager.contentsOfDirectory(atPath: directory.path)
        let tabs = contentsOfDirectory ?? []

        var tabSessions: [String: Data] = [:]

        for tab in tabs {
            let id = tab.trimmingPrefix(tabPrefix)
            if let data = try? Data(contentsOf: directory.appendingPathComponent(tab)) {
                tabSessions[String(id)] = data
            }
        }

        return tabSessions
    }

    private func tabDirectory() -> URL? {
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.web-browser")

        guard let directory = containerURL?.appendingPathComponent("tab-session-data") else { return nil }

        if !fileManager.fileExists(atPath: directory.path){
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                return nil
            }
        }

        return directory
    }
}
