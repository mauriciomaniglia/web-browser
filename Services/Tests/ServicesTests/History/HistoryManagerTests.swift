import XCTest
import Services

class HistoryManagerTests: XCTestCase {

    func test_didOpenHistoryView_deliversCorrectResult() {
        let (sut, history) = makeSUT()
        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let page1 = WebPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        let page2 = WebPageModel(title: "title 2", url: URL(string: "http://page2.com")!, date: today)
        let page3 = WebPageModel(title: "", url: URL(string: "http://page3.com")!, date: yesterday)
        history.mockWebPages = [page1, page2, page3]

        let presentableModel = sut.didOpenHistoryView()

        XCTAssertEqual(history.receivedMessages, [.getPages])
        XCTAssertEqual(presentableModel.list?.first?.pages[0].title, "12:00 - title 2")
        XCTAssertEqual(presentableModel.list?.first?.pages[0].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(presentableModel.list?.first?.pages[1].title, "07:00 - title 1")
        XCTAssertEqual(presentableModel.list?.first?.pages[1].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(presentableModel.list?.last?.pages[0].title, "12:00 - http://page3.com")
        XCTAssertEqual(presentableModel.list?.last?.pages[0].url, URL(string:"http://page3.com")!)
    }

    func test_didSearchTerm_deliversCorrectResult() async {
        let (sut, history) = makeSUT()
        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let page = WebPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        history.mockWebPages = [page]

        let presentableModel = await sut.didSearchTerm("test")

        XCTAssertEqual(history.receivedMessages, [.getPagesByTerm("test")])
        XCTAssertEqual(presentableModel.list?.first?.pages[0].title, "07:00 - title 1")
        XCTAssertEqual(presentableModel.list?.first?.pages[0].url, URL(string:"http://page1.com")!)
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() async {
        let (sut, history) = makeSUT()

        let presentableModel = await sut.didSearchTerm("")

        XCTAssertEqual(presentableModel.list, [])
        XCTAssertEqual(history.receivedMessages, [.getPages])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryManager<HistoryStoreMock>, historyStore: HistoryStoreMock) {
        let historyStore = HistoryStoreMock()
        let sut = HistoryManager(historyStore: historyStore)

        return (sut, historyStore)
    }
}
