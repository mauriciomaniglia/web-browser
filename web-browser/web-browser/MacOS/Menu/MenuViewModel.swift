import Foundation

enum MenuOption: Hashable {
    case bookmarks
    case history
}

final class MenuViewModel: ObservableObject {
    @Published var path: [MenuOption] = []

    func navigateToBookmarks() {
        path.append(.bookmarks)
    }

    func navigateToHistory() {
        path.append(.history)
    }
}
