import XCTest
import core_web_browser

class HistoryPresenterTests: XCTestCase {

    func test_didOpenHistoryView_deliversCorrectState() {
        let (sut, history) = makeSUT()

        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        let page1 = WebPage(title: "title 1", url: URL(string: "http://page1.com")!, date: dayBeforeYesterday)
        let page2 = WebPage(title: "", url: URL(string: "http://page2.com")!, date: yesterday)
        let page3 = WebPage(title: nil, url: URL(string: "http://page3.com")!, date: today)
        history.mockWebPages = [page1, page2, page3]
        var model: HistoryPresentableModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didOpenHistoryView()
        
        XCTAssertEqual(model.historyList?[0].title, "http://page3.com")
        XCTAssertEqual(model.historyList?[0].url, URL(string:"http://page3.com")!)
        XCTAssertEqual(model.historyList?[1].title, "http://page2.com")
        XCTAssertEqual(model.historyList?[1].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(model.historyList?[2].title, "title 1")
        XCTAssertEqual(model.historyList?[2].url, URL(string:"http://page1.com")!)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryPresenter, historyMock: HistoryStoreMock) {
        let history = HistoryStoreMock()
        let sut = HistoryPresenter(history: history)

        return (sut, history)
    }
}
