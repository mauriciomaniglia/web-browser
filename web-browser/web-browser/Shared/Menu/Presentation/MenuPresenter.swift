import core_web_browser

class MenuPresenter {
    var didUpdatePresentableModel: ((MenuPresentableModel) -> Void)?

    func didOpenMenuView() {
        let model = MenuPresentableModel(showMenu: true, showHistory: false)
        didUpdatePresentableModel?(model)
    }

    func didOpenHistoryView() {
        let model = MenuPresentableModel(showMenu: false, showHistory: true)
        didUpdatePresentableModel?(model)
    }
}
