import Services

class HistoryAdapter {
    private var viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: HistoryPresenter.Model) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(id: $0.id, title: $0.title, url: $0.url)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
