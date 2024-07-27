public class MenuPresenter {
    public var didUpdatePresentableModel: ((MenuPresentableModel) -> Void)?

    public init() {}

    public func didOpenMenuView() {
        let model = MenuPresentableModel(showMenu: true, showHistory: false)
        didUpdatePresentableModel?(model)
    }

    public func didOpenHistoryView() {
        let model = MenuPresentableModel(showMenu: false, showHistory: true)
        didUpdatePresentableModel?(model)
    }
}
