import Services

class HistoryAdapter {
    let viewModel: HistoryViewModel
    let manager: HistoryManager

    init(viewModel: HistoryViewModel, manager: HistoryManager) {
        self.viewModel = viewModel
        self.manager = manager
    }

    func didOpenHistoryView() {
        let model = manager.didOpenHistoryView()
        mapPresentableModel(model)
    }

    func didSearchTerm(_ query: String) {
        let model = manager.didSearchTerm(query)
        mapPresentableModel(model)
    }

    func mapPresentableModel(_ model: PresentableHistory) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(id: $0.id, title: $0.title, url: $0.url)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
