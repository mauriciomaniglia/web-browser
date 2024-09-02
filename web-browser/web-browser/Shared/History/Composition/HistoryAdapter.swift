import core_web_browser

class HistoryAdapter {
    private var viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }

    func updateViewModel(_ model: HistoryPresentableModel) {
        let history = model.list?.compactMap {
            let pages = $0.pages.map {
                HistoryViewModel.Page(title: $0.title, url: $0.url.absoluteString)
            }
            return HistoryViewModel.Section(title: $0.title, pages: pages)
        }

        viewModel.historyList = history ?? []
    }
}
