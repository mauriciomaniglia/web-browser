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

    func test_didOpenHistoryView_sendsCorrectMessage() {
        let (sut, history) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(history.receivedMessages, [.getPages])
    }

    func test_didSearchTerm_deliversCorrectState() {
        let (sut, history) = makeSUT()
        let page1 = WebPage(title: "Apple Store", url: URL(string: "http://apple-store.com")!, date: Date())
        let page2 = WebPage(title: "Apple Blog", url: URL(string: "http://apple-blog.com")!, date: Date())
        history.mockWebPages = [page1, page2]
        var model: HistoryPresentableModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didSearchTerm("apple")

        XCTAssertEqual(model.historyList?[0].title, "Apple Store")
        XCTAssertEqual(model.historyList?[0].url, URL(string:"http://apple-store.com")!)
        XCTAssertEqual(model.historyList?[1].title, "Apple Blog")
        XCTAssertEqual(model.historyList?[1].url, URL(string:"http://apple-blog.com")!)
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, history) = makeSUT()

        sut.didSearchTerm("apple")

        XCTAssertEqual(history.receivedMessages, [.getPagesByTerm("apple")])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryPresenter, historyMock: HistoryStoreMock) {
        let history = HistoryStoreMock()
        let sut = HistoryPresenter(history: history)

        return (sut, history)
    }
}
