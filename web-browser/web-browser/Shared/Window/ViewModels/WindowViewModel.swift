import Foundation

class WindowViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var showStopButton: Bool = false
    @Published var showReloadButton: Bool = false
    @Published var progressBarValue: Double? = nil
    @Published var url: String? = nil
    @Published var isWebsiteProtected: Bool = true
    @Published var showSiteProtection: Bool = false

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
    var didUpdateSafelist: ((String, Bool) -> Void)?
}
