import SwiftUI

extension TabBarManager {
    @MainActor
    func captureSnapshots() async {
        await withTaskGroup(of: Void.self) { group in
            for tab in tabs {
                group.addTask {
                    let image: UIImage? = await tab.webKitWrapper.takeSnapshot()

                    await MainActor.run {
                        tab.snapshot = image
                    }
                }
            }
        }
    }
}
