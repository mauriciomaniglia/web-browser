import SwiftUI

extension TabBarManager {
    func captureSnapshots(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        for tab in tabs {
            let webView = tab.webKitWrapper

            group.enter()

            webView.takeSnapshot() { image in
                DispatchQueue.main.async {
                    tab.snapshot = image
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}
