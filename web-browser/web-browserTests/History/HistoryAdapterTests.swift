import XCTest
@testable import Services
@testable import web_browser

class HistoryAdapterTests: XCTestCase {

    func test_updateViewModel_deliversCorrectState() {
        let (sut, viewModel) = makeSUT()
        let page = HistoryPresenter.Model.Page(id: UUID(), title: "title", url: URL(string: "https://some-url.com")!)
        let section = HistoryPresenter.Model.Section(title: "title", pages: [page])
        let model = HistoryPresenter.Model(list: [section])

        sut.updateViewModel(model)

        XCTAssertEqual(viewModel.historyList.first?.pages.first?.title, "title")
        XCTAssertEqual(viewModel.historyList.first?.pages.first?.url, URL(string:"https://some-url.com")!)        
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryAdapter, viewModel: HistoryViewModel) {
        let viewModel = HistoryViewModel()
        let sut = HistoryAdapter(viewModel: viewModel)

        return (sut, viewModel)
    }
}
