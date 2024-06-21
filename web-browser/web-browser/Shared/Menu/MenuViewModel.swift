import Foundation

class MenuViewModel: ObservableObject {

    @Published var showMenu: Bool = false

    var didTapMenuButton: (() -> Void)?
    var didTapHistoryOption: (() -> Void)?
}
