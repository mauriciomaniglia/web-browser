import Foundation

class WindowViewModel: ObservableObject {
    @Published var isBackButtonDisabled: Bool = true
    @Published var isForwardButtonDisabled: Bool = true
    @Published var progressBarValue: Double? = nil

    var didTapBackButton: (() -> Void)?
    var didTapForwardButton: (() -> Void)?
    var didStartSearch: ((String) -> Void)?
}
