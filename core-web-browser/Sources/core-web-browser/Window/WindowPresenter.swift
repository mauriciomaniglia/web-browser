public class WindowPresenter {
    public var didUpdatePresentableModel: ((WindowPresentableModel) -> Void)?
    private var model: WindowPresentableModel

    public init() {
        model = WindowPresentableModel(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: false,
            isPageOnWhitelist: false,
            showWebView: false,
            canGoBack: false,
            canGoForward: false)
    }

    public func didStartNewWindow() {
        didUpdatePresentableModel?(.init(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: false,
            isPageOnWhitelist: false,
            showWebView: false,
            canGoBack: false,
            canGoForward: false))
    }

    public func didStartEditing() {
        let newModel = WindowPresentableModel(
            showCancelButton: true,
            showStopButton: false,
            showReloadButton: false,
            isPageOnWhitelist: model.isPageOnWhitelist,
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
            isPageOnWhitelist: model.isPageOnWhitelist,
            showWebView: model.showWebView,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward)

        model = newModel
        didUpdatePresentableModel?(newModel)
    }

    public func didLoadPage(isOnWhitelist: Bool, canGoBack: Bool, canGoForward: Bool) {
        let newModel = WindowPresentableModel(
            showCancelButton: false,
            showStopButton: false,
            showReloadButton: true,
            isPageOnWhitelist: isOnWhitelist,
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
            isPageOnWhitelist: model.isPageOnWhitelist,
            showWebView: true,
            canGoBack: model.canGoBack,
            canGoForward: model.canGoForward,
            progressBarValue: progressValue))
    }
}
