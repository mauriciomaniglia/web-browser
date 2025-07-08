import XCTest
@testable import Services
@testable import web_browser

class BookmarkAdapterTests: XCTestCase {

    func test_updateViewModel_deliversCorrectState() {
        let (sut, viewModel) = makeSUT()
        let model1 = BookmarkPresenter.Model(id: UUID(), title: "title1", url: URL(string: "https://some-url.com")!)
        let model2 = BookmarkPresenter.Model(id: UUID(), title: "title2", url: URL(string: "https://some-other-url.com")!)

        sut.updateViewModel([model1, model2])

        XCTAssertEqual(viewModel.bookmarkList.first?.id, model1.id)
        XCTAssertEqual(viewModel.bookmarkList.first?.title, model1.title)
        XCTAssertEqual(viewModel.bookmarkList.first?.url, model1.url)
        XCTAssertEqual(viewModel.bookmarkList.last?.id, model2.id)
        XCTAssertEqual(viewModel.bookmarkList.last?.title, model2.title)
        XCTAssertEqual(viewModel.bookmarkList.last?.url, model2.url)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkAdapter, viewModel: BookmarkViewModel) {
        let viewModel = BookmarkViewModel()
        let sut = BookmarkAdapter(webView: WebViewSpy(), viewModel: viewModel)

        return (sut, viewModel)
    }
}
