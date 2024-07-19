import Foundation
import core_web_browser

class MenuViewModel: ObservableObject {
    let webView: WebEngineContract

    init(webView: WebEngineContract) {
        self.webView = webView
    }

    lazy var historyViewModel: HistoryViewModel = {
        HistoryComposer().makeHistoryViewModel(webView: webView)
    }()

    @Published var showMenu: Bool = false
    @Published var showHistory: Bool = false

    var didTapMenuButton: (() -> Void)?
    var didTapHistoryOption: (() -> Void)?
}
