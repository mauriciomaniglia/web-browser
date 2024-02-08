public class WindowPresenter {
    public var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    public init() {
        model = WindowPresentableModel(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: false,
            showPrivacyReportButton: false,
            showWebView: false,
            canGoBack: false,
            canGoForward: false)
    }

    public func didStartNewWindow() {
        didUpdatePresentableModel?(.init(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: false,
            showPrivacyReportButton: false,
            showWebView: false,
            canGoBack: false,
            canGoForward: false))
    }

    public func didStartEditing() {
        let newModel = WindowPresentableModel(
            showCancelButton: true,
            showStopButton: false,
            showReloadButton: false,
            showPrivacyReportButton: false,
            showWebView: model.showWebView,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didEndEditing() {
        let newModel = WindowPresentableModel(
            showCancelButton: false,
            showStopButton: model.showStopButton,
            showReloadButton: model.showReloadButton,
            showPrivacyReportButton: model.showPrivacyReportButton,
            showWebView: model.showWebView,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didLoadPage(canGoBack: Bool, canGoForward: Bool) {
        let newModel = WindowPresentableModel(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: true,
            showPrivacyReportButton: true,
            showWebView: true,
            canGoBack: canGoBack,
            canGoForward: canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didUpdateProgressBar(_ value: Double) {
        let progressValue = value >= 1 ? nil : value

        didUpdatePresentableModel?(.init(
            showCancelButton: false,
            showStopButton: true,
            showReloadButton: false,
            showPrivacyReportButton: true,
            showWebView: true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            progressBarValue: progressValue))
    }
}
