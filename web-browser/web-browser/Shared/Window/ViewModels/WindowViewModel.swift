import Foundation

class WindowViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var showCanceButton: Bool = false
    @Published var showStopButton: Bool = false
    @Published var showReloadButton: Bool = false
    @Published var showClearButton: Bool = false
    @Published var progressBarValue: Double? = nil
    @Published var urlHost: String? = nil
    @Published var fullURL: String = ""
    @Published var isWebsiteProtected: Bool = true
    @Published var showSiteProtection: Bool = false

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didLongPressBackButton: (() -> Void)?
    var didLongPressForwardButton: (() -> Void)?
    var didTapCancelButton: (() -> Void)?
    var didReload: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
    var didUpdateSafelist: ((String, Bool) -> Void)?
    var didBeginEditing: (() -> Void)?
    var didEndEditing: (() -> Void)?
}
