import XCTest
import core_web_browser

class HistoryPresenterTests: XCTestCase {

    func test_didLoadPages_deliversCorrectState() {
        let (sut, _) = makeSUT()

        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let page1 = WebPage(title: "title 1", url: URL(string: "http://page1.com")!, date: today)
        let page2 = WebPage(title: "", url: URL(string: "http://page2.com")!, date: yesterday)

        var model: HistoryPresentableModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didLoadPages([[page1, page2]])

        XCTAssertEqual(model.list?.first?.pages[0].title, "12:00 - title 1")
        XCTAssertEqual(model.list?.first?.pages[0].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(model.list?.first?.pages[1].title, "12:00 - http://page2.com")
        XCTAssertEqual(model.list?.first?.pages[1].url, URL(string:"http://page2.com")!)
    }

    func test_didSearchTerm_deliversCorrectState() {
        let (sut, history) = makeSUT()

        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!

        let page1 = WebPage(title: "Apple Store", url: URL(string: "http://apple-store.com")!, date: today)
        let page2 = WebPage(title: "Apple Blog", url: URL(string: "http://apple-blog.com")!, date: today)
        history.mockWebPages = [[page1, page2]]
        var model: HistoryPresentableModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didSearchTerm("apple")

        XCTAssertEqual(model.list?.first?.pages[0].title, "12:00 - Apple Store")
        XCTAssertEqual(model.list?.first?.pages[0].url, URL(string:"http://apple-store.com")!)
        XCTAssertEqual(model.list?.first?.pages[1].title, "12:00 - Apple Blog")
        XCTAssertEqual(model.list?.first?.pages[1].url, URL(string:"http://apple-blog.com")!)
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
