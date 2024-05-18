import Foundation

class WindowViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var progressBarValue: Double? = nil
    @Published var url: String? = nil
    @Published var isWebsiteProtected: Bool = true
    @Published var showSiteProtection: Bool = false

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
    var didUpdateWhitelist: ((String, Bool) -> Void)?
}
