import XCTest
import core_web_browser
@testable import web_browser

class MenuPresenterTests: XCTestCase {

    func test_didOpenMenuView_deliversCorrectModel() {
        let (sut, _) = makeSUT()
        var model: MenuModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didOpenMenuView()

        XCTAssertTrue(model.showMenu)
        XCTAssertNil(model.historyList)
    }

    func test_didOpenHistoryView_deliversCorrectModel() {
        let (sut, history) = makeSUT()
        let page1 = WebPage(title: "title 1", url: URL(string: "http://page1.com")!)
        let page2 = WebPage(title: "", url: URL(string: "http://page2.com")!)
        let page3 = WebPage(title: nil, url: URL(string: "http://page3.com")!)
        history.mockWebPages = [page1, page2, page3]
        var model: MenuModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didOpenHistoryView()

        XCTAssertFalse(model.showMenu)
        XCTAssertEqual(model.historyList?[0].title, "title 1")
        XCTAssertEqual(model.historyList?[0].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(model.historyList?[1].title, "http://page2.com")
        XCTAssertEqual(model.historyList?[1].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(model.historyList?[2].title, "http://page3.com")
        XCTAssertEqual(model.historyList?[2].url, URL(string:"http://page3.com")!)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: MenuPresenter, historyMock: HistoryStoreMock) {
        let history = HistoryStoreMock()
        let sut = MenuPresenter(history: history)

        return (sut, history)
    }
}
