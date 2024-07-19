import core_web_browser

class MenuPresenter {
    var didUpdatePresentableModel: ((MenuModel) -> Void)?

    func didOpenMenuView() {
        let model = MenuModel(showMenu: true, showHistory: false)
        didUpdatePresentableModel?(model)
    }

    func didOpenHistoryView() {
        let model = MenuModel(showMenu: false, showHistory: true)
        didUpdatePresentableModel?(model)
    }
}
