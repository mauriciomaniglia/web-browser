import Foundation

actor TabSessionStore {
    let fileManager = FileManager.default

    func saveTabSession(tabID: UUID, sessionData: Data) async {
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.web-browser")

        guard let directory = containerURL?.appendingPathComponent("tab-session-data") else { return }

        if !fileManager.fileExists(atPath: directory.path){
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                print("Ops")
            }
        }

        let path = directory.appendingPathComponent("tab-" + tabID.uuidString)

        do {
            try sessionData.write(to: path, options: .atomicWrite)
        } catch {
            print("Opss")
        }
    }

    func deleteTabSession(tabID: UUID) async {
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.web-browser")

        guard let directory = containerURL?.appendingPathComponent("tab-session-data") else { return }

        if !fileManager.fileExists(atPath: directory.path){
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                print("Ops")
            }
        }

        let path = directory.appendingPathComponent("tab-" + tabID.uuidString)

        do {
            try fileManager.removeItem(at: path)
        } catch {
            print("Opss")
        }
    }

    func getTabSessions() async -> [String: Data]? {
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.web-browser")

        guard let directory = containerURL?.appendingPathComponent("tab-session-data") else { return nil }

        let contentsOfDirectory = try? fileManager.contentsOfDirectory(atPath: directory.path)
        let tabs = contentsOfDirectory ?? []

        var tabSessions: [String: Data] = [:]

        for tab in tabs {
            let id = tab.trimmingPrefix("tab-")
            if let data = try? Data(contentsOf: directory.appendingPathComponent(tab)) {
                tabSessions[String(id)] = data
            }
        }

        return tabSessions
    }
}
